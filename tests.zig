const std = @import("std");
const builtin = @import("builtin");

const mem = std.mem;
const math = std.math;
const bi = std.builtin;
const heap = std.heap;
const debug = std.debug;
const testn = std.testing;

const print = debug.print;

pub fn percOf(f:comptime_float, s:usize) usize {
  const convs = @as(f64, @floatFromInt(s));
  const rf = math.floor(f * convs);
  return @as(usize, @intFromFloat(rf));
}

pub fn writeTo(str:[]u8, tw:anytype) !void {
  var i:usize = 0;
  while (i < str.len) : (i += 1) {
    str[i] = tw[i];
  }
}

test "sub-location" {
  const allocat:mem.Allocator = heap.page_allocator;

  var moson = try allocat.alloc(u8, 25);
  defer allocat.free(moson);
  try testn.expect(moson.len == 25);

  for (0..moson.len) |i| {
    moson[i] = 0;
  }

  try writeTo(moson, "m o o c o w w e e w o w a");
  const molo = " waka";

  const omem = moson;
  moson = try allocat.realloc(omem, (moson.len + molo.len)*2);
  // try testn.expect(moson.len == (moson.len + molo.len) * 2);

  for (25..moson.len) |i| {
    moson[i] = 0;
  }


  var i:usize = 0;
  var j:usize = 0;
  var k:usize = 0;
  const p:usize = 17;

  const lumvo = moson[p..(moson.len - 1)];
  print("{s}\n", .{moson[p..moson.len - 1]});
  i = p;
  while (i < moson.len) : (i += 1) {
    moson[i] = 0;
  }

  i = 0;

  while (i < moson.len) : (i += 1) {
    if (moson[i] != 0) continue;

    if (j < molo.len) {
      moson[i] = molo[j];
      j += 1;
      continue;
    }
    print("{any}", .{j});

    if (k < lumvo.len) {
      moson[i] = lumvo[k];
      k += 1;
      continue;
    }
  }

  print("{s}\n", .{moson});
}