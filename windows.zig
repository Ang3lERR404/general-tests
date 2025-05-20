pub const FileDevice = enum(u32) {
  beep = 0x1,
  cdRom = 0x2,
  cdRomFS = 0x3,
  controller = 0x4,
  dataLink = 0x5,
  dfs = 0x6,
  disk = 0x7,
  diskFS = 0x8,
  fileSystem = 0x9,
  inportPort = 0xa,
  keyboard = 0xb,
  mailslot = 0xc,
  midiIn = 0xd,
  midiOut = 0xe,
  mouse = 0xf,
  multiUNCProvider = 0x10,
  namedPipe = 0x11,
  network = 0x12,
  networkBrowser = 0x13,
  networkFS = 0x14,
  nUll = 0x15,
  parallelPort = 0x16,
  physNetcard = 0x17,
  printer = 0x18,
  scanner = 0x19,
  serialMousePort = 0x1a,
  serialPort = 0x1b,
  screen = 0x1c,
  sound = 0x1d,
  streams = 0x1e,
  tape = 0x1f,
  tapeFS = 0x20,
  transport = 0x21,
  unknown = 0x22,
  video = 0x23,
  virtualDisk = 0x24,
  waveIn = 0x25,
  waveOut = 0x26,
  edftPort = 0x27,
  networkRedirector = 0x28,
  battery = 0x29,
  busExtender = 0x2a,
  modem = 0x2b,
  vdm = 0x2c,
  massStorage = 0x2d,
  smb = 0x2e,
  ks = 0x2f,
  changer = 0x30,
  smartcard = 0x31,
  acpi = 0x32,
  dvd = 0x33,
  fullscreenVideo = 0x34,
  dfsFS = 0x35,
  dfsVolume = 0x36,
  serenum = 0x37,
  termsrv = 0x38,
  ksec = 0x39,
  fips = 0x3a,
  infiniband = 0x3b,
  vmbus = 0x3e,
  cryptProvider = 0x3f,
  wpd = 0x40,
  bluetooth = 0x41,
  mtComposit = 0x42,
  mtTransport = 0x43,
  biometric = 0x44,
  pmi = 0x45,
  ehstor = 0x46,
  devAPI = 0x47,
  gpio = 0x48,
  usbex = 0x49,
  console = 0x50,
  nfp = 0x51,
  sysEnv = 0x52,
  virtualBlock = 0x53,
  pos = 0x54,
  storageReplication = 0x55,
  trustEnv = 0x56,
  ucm = 0x57,
  ucmtcpci = 0x58,
  persistentMemory = 0x59,
  nvdimm = 0x5a,
  holographic = 0x5b,
  sdfxhci = 0x5c
};

pub const TransferMethod = enum(u2) {
  buffered = 0,
  inDirect = 1,
  outDirect = 2,
  neither = 3
};

pub const FileAccess = enum(u2) {
  any = 0,
  read = 1,
  write = 2
};

pub fn ctrlCode(deviceType:u16, function:u12, method:TransferMethod, access:u2) u32 {
  return (@as(u32, deviceType) << 16) |
    (@as(u32, access) << 14) |
    (@as(u32, function) << 2) |
    @intFromEnum(method);
}

pub const FileInfo = extern struct {
  pub const Basic = extern struct {
    creationTime:i64,
    lastAccessTime:i64,
    lastWriteTime:i64,
    changeTime:i64,
    fileAttributes:u32
  };
  pub const Standard = extern struct {
    allocationSize:i64,
    EOF:i64,
    numberOfLinks:u32,
    deletePending:u8,
    directory:u8
  };
  pub const Internal = extern struct {
    iNumber:i64
  };
  pub const EA = extern struct {
    size:u32
  };
  pub const Access = extern struct {
    flags:u32
  };
  pub const Position = extern struct {
    byteOffset:i64
  };
  pub const EOF = extern struct {
    eof:i64
  };
  pub const Mode = extern struct {
    mode: u32
  };
  pub const Alignment = extern struct {
    requirement:u32
  };
  pub const Name = extern struct {
    length:u32,
    name:[1]u16
  };
  pub const Disposition = extern struct {
    flags:u32
  };

  BasicInfo:Basic,
  StandardInfo:Standard,
  InternalInfo:Internal,
  EAInfo:EA,
  AccessInfo:Access,
  PositionInfo:Position,
  ModeInfo:Mode,
  AlignmentInfo:Alignment,
  NameInfo:Name
};