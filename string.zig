const std = @import("std"); const builtin = @import("builtin");

const This = @This();

pub const errors = error{
  ResizeFailure, AppendFailure, AllocateFailure, Empty,
  OutOfMemory, InvalidIndex, InvalidRange, FormattingFailure
};

const mem = std.mem; const heap = std.heap; const debug = std.debug; const testing = std.testing;
const Allocat = mem.Allocator; const unicode = std.unicode;

const print = debug.print; const assert = debug.assert; const expect = testing.expect;

buff:?[]u8, len:usize, cat:Allocat, origBuff:?[]u8,

pub fn init(cat:Allocat) This {
  return This{
    .buff = undefined,
    .len = 0,
    .cat = cat,
    .origBuff = undefined
  };
}

pub fn initWD(cat:Allocat, str:anytype) This {
  var stor = init(cat);
  stor.alloc(str.len);
  stor.write(str);
  return stor;
}

pub fn free(this:This, memor:anytype) void {
  this.cat.free(memor);
}

pub fn deinit(this:This) void {
  if (this.len == 0) return;
  this.cat.free(this.buff.?);
}

pub fn clear (this:*This, s:usize, e:usize) *This {
  var i = s;
  while (i < e) : (i += 1)
    this.buff.?[i] = 0;
  return this;
}

pub fn alloc(this:*This, comptime size:usize) errors!*This {
  const oL = this.len;
  if (this.len > 0) {
    if (size < this.len) this.len = size;
    this.buff.? = this.cat.realloc(this.buff.?, size) catch return errors.AllocateFailure;
    this.clear(oL, this.buff.?.len);
    this.len = this.buff.?.len;
    return this;
  }
  this.buff.? = this.cat.alloc(u8, size) catch return errors.AllocateFailure;
  this.len = this.buff.?.len;
  this.clear(0, this.len);
  return this;
}

pub fn addAlloc(this:*This, comptime size:usize) errors!*This {
  const oL = this.len;
  this.buff.? = this.cat.realloc(this.buff.?, oL + size) catch return errors.AllocateFailure;
  this.clear(oL, this.buff.?.len);
  this.len = this.buff.?.len;
  return this;
}

pub fn write(this:*This, str:anytype) *This {
  var i:usize = 0;
  while (i < str.len) : (i += 1)
    this.buff.?[i] = str[i];
  return this;
}

pub fn writeFrom(this:*This, str:anytype, s:usize) *This {
  var i:usize = 0;
  while (i < this.len) : (i += 1) {
    if (this.buff.?[i] != 0) continue;
    if (i != s) continue;
    var j:usize = 0;
    while (j < str.len) : (j += 1)
      this.buff.?[i + j] = str[j];
    break;
  }
  return this;
}

pub fn truncate (this:*This) !*This {
  try this.alloc(this.len);
  return this;
}

pub fn eql(this:*This, str:anytype) bool {
  return mem.eql(u8, this.buff.?, str);
}

pub fn toStr(this:*This) []const u8 {
  if (this.buff) |buff| return buff[0..this.len];
  return "";
}

pub fn pop(this:*This) ?u8 {
  if (this.len == 0) return null;
  if (this.buff) |buff| {
    var i:usize = 0;
    while(i < this.len) {
      const size = This.getUTF8Size(buff[i]);
      if (i + size >= this.len) break;
      i += size;
    }
    const ret = buff[i..this.len];
    this.len -= (this.len - i);
    return ret;
  }
  return null;
}

pub fn getIndex(unic:[]const u8, i:usize, real:bool) ?usize {
  var j:usize = 0; var k:usize = 0;
  while (j < unic.len) {
    if (real)
      if (k == i) return j;
    if (j == i) return k;

    j += This.getSize(unic[j]);
    k += 1;
  }
  return null;
}

inline fn getSize(char:u8) u3 {
  return unicode.utf8ByteSequenceLength(char) catch {
    return 1;
  };
}

pub fn charAt(this:*This, i:usize) ?[]const u8 {
  if (this.buff) |buff| {
    if (This.getIndex(buff, i, true)) |j| {
      return buff[j..(j + This.getSize(buff[j]))];
    }
  }
  return null;
}

pub fn own(this:*This) !?[]u8 {
  if (this.buff != null) {
    const str = this.toStr();
    if (this.cat.alloc(u8, str.len)) |nStr| {
      mem.copyForwards(u8, nStr, str);
      return nStr;
    } else |_| return errors.OutOfMemory;
  }
  return null;
}

pub fn rem(this:*This, ind:usize) !*This {
  try this.remRange(ind, ind+1);
  return this;
}

pub fn remRange(this:*This, s:usize, e:usize) errors!*This {
  const len = this.len;
  if (e < s or e > len) return errors.InvalidRange;

  if (this.buff) |buff| {
    const rS = This.getIndex(buff, s, true).?;
    const rE = This.getIndex(buff, e, true).?;
    const dif = rE - rS;

    var i:usize = rE;
    while (i < len) : (i += 1) buff[i - dif] = buff[i];
    this.len -= dif;
  }
  return this;
}

pub fn find(this:*This, litrl:[]const u8, revr:bool) ?usize {
  if (this.buff) |buff| {
    const ind = if (!revr)
      mem.indexOf(u8, buff[0..this.len], litrl)
    else
      mem.lastIndexOf(u8, buff[0..this.len], litrl);
    
    if (ind) |i|
      return This.getIndex(buff, i, false);
  }
  return undefined;
}

pub fn rev(this:*This) *This {
  if (this.buff) |buff| {
    var i:usize = 0;
    while (i < this.len) {
      const len = This.getSize(buff);
      if (len > 1) mem.reverse(u8, buff[i..(i+len)]);
      i += len;
    }

    mem.reverse(u8, buff[0..this.len]); 
  }
  return this;
}

pub fn trim(this:*This, whitelist:[]const u8) *This {
  if (this.buff) |buff| {
    var i:usize = 0;
    while (i < this.len) : (i += 1) {
      const len = This.getSize(buff[i]);
      if (len > 1 or !This.inWhitelist(buff[i], whitelist)) break;
    }

    if (This.getIndex(buff, i, false)) |k|
      this.remRange(0, k) catch {};
  }
  return this;
}

fn inWhitelist(char:u8, whitelist:[]const u8) bool {
  var i:usize = 0;
  while (i < whitelist.len) : (i += 1) 
    if (whitelist[i] == char) return true;
  return false;
}

pub fn isUTF8(b:u8) bool {
  return ((b & 0x80) > 0) and (((b << 1) & 0x80) == 0);
}

pub fn assumeWrite(this:*This, str:anytype) !*This {
  try this.alloc(str.len);
  this.write(str);
  return this;
}

pub fn assumeWriteFrom(this:*This, str:anytype, s:usize) !*This {
  try this.addAlloc(str.len);
  this.writeFrom(str, s);
  return this;
}

const fmt = std.fmt;

// fmt.allocPrintZ

pub fn f(this:*This, comptime fmStr:[]const u8, args:anytype) errors!*This {
  this.origBuff = this.own();
  this.buff.? = try fmt.allocPrint(this.cat, fmStr, args) catch return errors.FormattingFailure;
  return this;
}

const pageCat = testing.allocator;
test {
  print("Is string empty?..", .{});
  var str = This.init(pageCat);
  defer str.deinit();

  assert(str.len == 0);
  print(" yes[0/6]\n\nHas allocated memory?..", .{});

  _ = try str.alloc(5);
  assert(str.len > 0);
  print(" yes[1/6]\n\nCan write to it?..", .{});

  _ = str.write("hello");
  assert(str.eql("hello"));
  print(" yes[2/6]\n\nCan expand correctly?..", .{});

  _ = try str.addAlloc(6);
  assert(str.len == 11);
  print(" yes[3/6]\n\nCan append correctly?..", .{});
  
  _ = str.writeFrom(" world", 5);
  assert(str.eql("hello world"));
  print(" yes[4/6]\n\nCan clear correctly?..", .{});

  _ = str.clear(0, str.len);
  var j:usize = 0;
  var tru:bool = false;
  while (j < str.len) : (j += 1) {
    if (str.buff) |buff| {
      if (buff[j] == 0) {
        tru = true;
        continue;
      }
      tru = false;
      break;
    }
  }
  assert(tru);
  print("yes[5/6]\n\nCan assume size and write?..", .{});
  _ = try str.assumeWrite("Wompa");
  assert(str.eql("Wompa"));
  print("yes[6/6]\n", .{});
  print("Test complete\nFinal string: {s}\n\n", .{str.toStr()});
}