const std = @import("std");
const builtin = @import("builtin");

const Allocat = std.mem.Allocator;

const print = std.debug.print;
const expect = std.testing.expect;
const eql = std.mem.eql;

test {
  
}

// const mHV:u32 = 4294967295;

// // A hash table is a simple generator function that takes in a string
// // and outputs a hashed version of said string.

// pub fn hash(str:anytype) !u32 {
//   var bp:u16 = undefined;
//   bp += str[0] + str[1];
//   var ep:u16 = undefined;
//   ep += str[str.len - 1] + str[str.len - 2];

//   return @as(u32, (bp) | ep);
// }

// test {
//   const wim = try hash("let");
//   print("{any}\n", .{wim});
// }

// pub fn gen(str:anytype, wl:WordList) ?[]const u8 {
//   const k:u32 = hash("hallaluja");
//   if (!k <= mHV) return null;

//   const s:*[]u8 = wl[k];
//   if (!(str.* == s.* and !std.mem.eql(u8, str[1..], s[1..s.len - 1]) and s[s.len - 1] == '\0')) return null;

//   return &wl[k];
// }

// const std = @import("std");

// const print = std.debug.print;
// const Allocat = std.mem.Allocator;
// const pageCat = std.heap.page_allocator;

// a hash table is a simple generator function that takes in a string
// and outputs a hashed version of string.

// pub fn hsh(comptime T:type, str:anytype, cat:Allocat) ![]T {
//   var nstr:[]T = undefined;
//   nstr = try cat.alloc(T, 25);

//   if (nstr.len > str.len) nstr.len = str.len;

//   var i:usize = 0;
  
//   while (i < str.len) : (i += 1) {
//     const ch = str[i];
//     nstr[i] = @as(T, ch) << 1;
//   }

//   return nstr;
// }

// pub fn main() !void {
//   var sup = std.heap.HeapAllocator.init();
//   defer sup.deinit();
//   const catty = sup.allocator();
//   const String = std.ArrayList([]u8);

//   var strs = String.init(catty);
//   defer strs.deinit();
//   try strs.appendSlice(&[_][]u8{
//     @constCast("if"),
//     @constCast("if else"),
//     @constCast("else"),
//     @constCast("+"),
//     @constCast("-")
//   });

//   const fstrs = try strs.toOwnedSlice();
//   for (fstrs) |str| {
//     const wem = try hsh(u8, @constCast(str), catty);
//     print("{usize}\n", .{wem});
//   }
// }