const std = @import("std");
const builtin = @import("builtin");
const This = @This();

/// Common errors for strings
pub const errors = error{
  ResizeFailure, AppendFailure,
  AllocateFailure, Empty,
  OutOfMemory, InvalidIndex
};

const mem = std.mem;
const heap = std.heap;
const debug = std.debug;
const testing = std.testing;

const Allocat = mem.Allocator;

const print = debug.print;
const assert = debug.assert;
const expect = testing.expect;

/// The data that is being stored
data:[]u8,
/// The length of said data
len:usize,
/// The user passed allocator that will be handling the memory.\
/// Which is abbreviated to cat :3
cat:Allocat,

/// Initialize the empty string
pub fn init(cat:Allocat) This {
  return This{
    .cat = cat,
    .len = 0,
    .data = undefined
  };
}
/// Initialize the empty string and write data to it.
pub fn initWD(cat:Allocat, str:anytype) This {
  var stor = init(cat);
  stor.alloc(str.len);
  stor.write(str);
  return stor;
}

/// Shortcut method of this.cat.free(...)
pub fn free(this:This, memor:anytype) void {
  this.cat.free(memor);
}

/// Free the string from memory.
pub fn deinit(this:This) void {
  if (this.len == 0) return;
  this.cat.free(this.data);
}

/// Clear the string of its data.
pub fn clear(this:*This, s:usize, e:usize) void {
  var i = s;
  while(i < e) : (i += 1)
    this.data[i] = 0;
}

/// Allocate memory/Resize memory to the passed size.
pub fn alloc(this:*This, comptime size:usize) errors!void {
  const oL = this.len;
  if (this.len > 0) {
    if (size < this.len) this.len = size;
    this.data = this.cat.realloc(this.data, size) catch return errors.AllocateFailure;
    this.clear(oL, this.data.len);
    this.len = this.data.len;
    return;
  }

  this.data = this.cat.alloc(u8, size) catch return errors.AllocateFailure;
  this.len = this.data.len;
  this.clear(0, this.len);
}

/// Add to the already existing allocated size.
pub fn addAlloc(this:*This, comptime size:usize) errors!void {
  const oL = this.len;
  this.data = this.cat.realloc(this.data, oL + size) catch return errors.AllocateFailure;
  this.clear(oL, this.data.len);
  this.len = this.data.len;
}

/// Plainly writes data to our string whilst not being connected to
/// overcomplicated methods.
pub fn write(this:*This, str:anytype) void {
  var i:usize = 0;
  while (i < str.len) : (i += 1) 
    this.data[i] = str[i];
}
/// Plainly writes data to our string from the passed start index
/// whilst not being connected to any overcomplicated methods.
pub fn writeFrom(this:*This, str:anytype, s:usize) void {
  var i:usize = 0;
  while (i < this.len) : (i += 1) {
    if (this.data[i] != 0) continue;

    if (i == s) {
      var j:usize = 0;
      while (j < str.len) : (j += 1)
        this.data[i + j] = str[j];
      break;
    }
  }
}

/// String == string literal
pub fn eql(this:*This, str:anytype) bool {
  return std.mem.eql(u8, this.data, str);
}

const pageCat = testing.allocator;
test {
  print("Is string empty?..", .{});
  var str = This.init(pageCat);
  defer str.deinit();

  assert(str.len == 0);
  print(" yes[0/4]\nHas allocated memory?..", .{});
  
  try str.alloc(5);
  assert(str.len > 0);
  print(" yes[1/4]\nCan write to it?..", .{});

  str.write("hello");
  assert(str.eql("hello"));
  print(" yes[2/4]\nCan expand correctly?..", .{});

  try str.addAlloc(6);
  assert(str.len == 11);
  print(" yes[3/4]\nCan append correctly?..", .{});

  str.writeFrom(" world", 5);
  assert(str.eql("hello world"));
  print(" yes[4/4]\n", .{});
}