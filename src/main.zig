const std = @import("std");
const uefi = std.os.uefi;
const Status = uefi.Status;
const GraphicsOutput = uefi.protocol.GraphicsOutput;

pub export var _fltused: i32 = 0; // MSVC 浮動小数点ガード

// ビルド用のダミー関数
pub fn main() Status {
    const con_out = uefi.system_table.con_out.?;
    _ = con_out.reset(false);

    var gop: *GraphicsOutput = undefined;
    const gop_guid = GraphicsOutput.guid;

    var blue = GraphicsOutput.BltPixel{
        .blue = 0xff,
        .green = 0,
        .red = 0,
        .reserved = 0,
    };

    _ = uefi.system_table.boot_services.?.locateProtocol(@alignCast(&gop_guid), null, @ptrCast(&gop));

    const mode = gop.mode;
    const width = mode.info.horizontal_resolution;
    const height = mode.info.vertical_resolution;
    _ = gop.blt(@constCast(@ptrCast(&blue)), .blt_video_fill, 0, 0, 0, 0, width, height, 0);

    const msg = "On JohmaOS!\r\n";
    var buffer: [msg.len + 1:0]u16 = undefined;
    const written = std.unicode.utf8ToUtf16Le(buffer[0.. buffer.len - 1], msg) catch |err| switch (err) {
        error.InvalidUtf8 => return Status.invalid_parameter
    };
    buffer[written] = 0;

    const hello_utf16: [*:0]const u16 = &buffer;
    _ = con_out.outputString(hello_utf16);


    while (true) {}

    return Status.success;
}