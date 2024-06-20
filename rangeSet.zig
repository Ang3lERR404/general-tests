const std = @import("std");

const debug = std.debug;
const mem = std.mem;
const math = std.math;

const print = debug.print;

const Allocat = mem.Allocator; // mow .w.
const ArrayList = std.ArrayList;

pub fn range(comptime T:type) type {
  const This:range(T) = @This();
  return struct {
    min:T,
    max:T,

    pub fn new(min:T, max:T) This {
      debug.assert(min <= max);
      return This{.min = min, .max = max};
    }

    pub fn single(item:T) This {
      return This{.min = item, .max = item};
    }
  };
}

pub fn rangeSet(comptime T:type) type {
  return struct {
    const This = @This();
    const rangeT = range(T);
    const Li = math.minInt(T);
    const Mi = math.maxInt(T);

    ranges: ArrayList(rangeT),

    pub fn init(acat:Allocat) This {
      return This{
        .ranges = ArrayList(rangeT).init(acat)
      };
    }

    pub fn deinit(this:*This) void {
      this.ranges.deinit();
    }

    pub fn clone(this:This) !This {
      return This{.ranges = try this.ranges.clone()};
    }

    pub fn dupe(this:This, acat:Allocat) !This {
      var cloned = try ArrayList(rangeT).initCapacity(acat, this.ranges.items.len);
      cloned.appendSliceAssumeCapacity(this.ranges.items);
      return This{.ranges = cloned};
    }

    pub fn add(this:*This, rang:rangeT) !void {
      var ranges = &this.ranges;

      if (ranges.items.len == 0) {
        try ranges.append(rang);
        return;
      }

      for (ranges.items, 0..) |r, i| {
        if (rang.min <= r.min) {
          try ranges.insert(i, rang);
          break;
        }
      } else {
        try ranges.append(rang);
      }

      var i:usize = 0;
      var merm = ranges.items[0];

      for (ranges.items[1..]) |r| {
        const up = math.add(T, merm.max, 1) catch Mi;
        if (r.min <= up) merm.max = @max(merm.max, r.max)
        else {
          ranges.items[i] = merm;
          merm = r;
          i += 1;
        }
      }

      ranges.items[i] = merm;
      i += 1;
      ranges.shrinkRetainingCapacity(i);
    }

    pub fn merge(this:*This, other:This) !void {
      for (other.ranges.items) |r| {
        try this.add(r);
      }
    }

    pub fn negate (this:*This) !void {
      const ranges = &this.ranges;
      const rEnd = this.ranges.items.len;

      const nR = &this.ranges;
      const nS = this.ranges.items.len;

      if (ranges.items.len == 0) {
        try ranges.append(rangeT.new(Li, Mi));
        return;
      }

      var l:T = Li;
      for (ranges.items[0..rEnd], 0..) |r, i| {
        if (i == 0 and r.min != Li) try nR.append(rangeT.new(l, r.min - 1));
        l = math.add(T, r.max, 1) catch Mi;
      }

      const lR = ranges.items[rEnd - 1];
      if (lR.max != Mi) {
        try nR.append(rangeT.new(l, Mi));
      }

      mem.copyForwards(rangeT, ranges.items, ranges.items[nS..]);
      ranges.shrinkRetainingCapacity(nR.items.len - nS);
    }

    pub fn contains(this:This, v:T) bool {
      for 
    }
  };
}