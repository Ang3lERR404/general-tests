//! Useful little utility fn that makes type information access just a tad easier
const std = @import("std");
const This = @This();
const Allocat = std.mem.Allocator;

const print = std.debug.print;

pub const errors = error{
  FailureToCoerce
};

///Type data reference.
T:type,
///Information on said type.
info:std.builtin.Type,
size:comptime_int,

///Initialize the data provider.
pub fn init(v:type) This {
  var tom = This{
    .T = v,
    .info = undefined,
    .size = undefined,
  };

  tom.info = @typeInfo(tom.T);
  tom.size = @sizeOf(tom.T);
  return tom;
}

pub fn deref(this:*const This) this.T {
  return switch (this.info) {
    .Pointer => |pinf| switch (pinf.size) {
      .Slice => @Type(std.builtin.Type.Array{
        .child = pinf.child,
        .len = this.size,
        .sentinel = pinf.sentinel
      }),
      else => undefined
    },
    else => undefined
  };
  // if (this.info.Pointer) |mol| return mol.child;
}

test This {
  const mulnir = This.init(@TypeOf("moo cow"));

  print("\n{any}\n\n{any}\n\n{any}\n", .{mulnir.T, mulnir.info, mulnir.size});
}