const std = @import("std");
const builtin = @import("builtin");

const Allocat = std.mem.Allocator;

const print = std.debug.print;
const expect = std.testing.expect;
const eql = std.mem.eql;

pub const Answer = struct {
  const This = @This();
  content:[]const u8,
  cat:Allocat,
  pub fn free(this:This) void {
    this.cat.free(this.content);
  }
};

pub fn ask(prompt:anytype, cat:Allocat) !Answer {
  const stdin = std.io.getStdIn().reader();
  const stdout = std.io.getStdOut().writer();

  try stdout.print("${s}> ", .{prompt});
  const buf = try stdin.readUntilDelimiterOrEofAlloc(cat, '\r', 1024);
  return Answer {
    .content = buf.?,
    .cat = cat
  };
}

test "asky" {
  const resp = try ask("Hi what's your name?", std.heap.page_allocator);
  defer resp.free();

  print("{s}", .{resp.content});

}