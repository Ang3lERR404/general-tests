const std = @import("std");
const builtin = @import("builtin");

const Allocat = std.mem.Allocator;

const print = std.debug.print;
const expect = std.testing.expect;
const eql = std.mem.eql;

const This = @This();


pub const Node = struct {
  const Thi1 = @This();

  pub const Is = enum{first, between, last};

  pub const State = struct {
    pub const Typex = enum {idname, idval, literal, symbol, binary};

    pub const States = enum {expression, statement, func, typex};
    state:States,
    type:Typex,
    
    fn init(state:States, typ:Typex) State {
      return State {
        .state = state,
        .type = typ
      };
    }
  };

  data:[]u8, i:usize, is:Is, prev:*Thi1, nex:*Thi1, children:*[]Thi1,
  cat:Allocat, size:usize, type:State,

  fn init(data:anytype, i:usize, is:Is, cat:Allocat) Thi1 {
    return Thi1{
      .data = @constCast(data), .i = i, .is = is,
      .children = undefined, .prev = undefined, .nex = undefined,
      .cat = cat, .size = undefined
    };
  }

  pub fn deinit(this:*Thi1) void {
    if (!@sizeOf(@TypeOf(this.data)) > 0) return;
    this.cat.free(this.data);
  }
};

children:*[]Node,
size:usize,
first:*Node,
last:*Node