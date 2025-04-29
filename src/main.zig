const std = @import("std");
const uefi = std.os.uefi;
const Status = uefi.Status;

pub export var _fltused: i32 = 0; // MSVC 浮動小数点ガード

// ビルド用のダミー関数
pub fn main() Status {
    const con_out = uefi.system_table.con_out.?;
    _ = con_out.reset(false);

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