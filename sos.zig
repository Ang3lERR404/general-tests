const std = @import("std");
const builtin = @import("builtin");

const Allocat = std.mem.Allocator;
const debug = std.debug;
const testing = std.testing;
const mem = std.mem;
const heap = std.heap;

const print = std.debug.print;
const expect = std.testing.expect;
const eql = std.mem.eql;

pub const Can = struct {
  mutate:bool = false
};

pub const Array = struct{
  const This = @This();
  type:type,
  len:usize = 0,
  items:*anyopaque = undefined,
  can:Can = .{.mutate = false},

  fn init(comptime T:type) This {
    return This{
      .type = T
    };
  }

  pub fn free(this:This) void {
    if (!this.len > 0) return;
    this.items = undefined;
    this.len = 0;
  }

  pub fn form(this:*This, items:anytype) !void {
    var i:usize = 0;
    while (i < items.len) : (i += 1) {
      const item = items[i];
      if (@TypeOf(item) != this.type) unreachable;
      
      // @compileLog(item, @TypeOf(item) == this.type);
    }
  }
};

test "?" {
  print("{any} bytes\n", .{@sizeOf(u32)});
  // 00000000, 00000000, 00000000, 00000000
  // 32 / 8 = 4
  // u32 = an unsigned integer that is 32 bits/4 bytes wide
  

  comptime {
    var str = Array.init(u8);
    str.len = 2;

    try str.form(&[_]u8{
      'h', 'i'
    });

    print(str, .{});
    // print("\n{any}\n", .{str});
  }
}