const std = @import("std");
const cat = std.mem.Allocator;

const heap = std.heap;
const process = std.process;
const mem = std.mem;
const debug = std.debug;
const fs = std.fs;


const cMap = enum(u8) {
 A = 0x00, B = 0x01, C = 0x02, D = 0x03, E = 0x04

};

const cMap = [64:0] u8{
  'A', 'B', 'C', 'D', 'E', 'F',
  'G', 'H', 'I', 'J', 'K', 'L',
  'M', 'N', 'O', 'P', 'Q', 'R',
  'S', 'T', 'U', 'V', 'W', 'X',
  'Y', 'Z', 'a', 'b', 'c', 'd',
  'e', 'f', 'g', 'h', 'i', 'j',
  'k', 'l', 'm', 'n', 'o', 'p',
  'q', 'r', 's', 't', 'u', 'v',
  'w', 'x', 'y', 'z', '0', '1',
  '2', '3', '4', '5', '6', '7',
  '8', '9', '+', '=', '/'
};

pub fn main () anyerror!void {
  const catty = 
}