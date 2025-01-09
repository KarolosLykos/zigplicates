const std = @import("std");

const data = @embedFile("README.md");
const split = std.mem.split;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Create a StringHashMap for checking duplicate URLs
    var url_map = std.StringHashMap(u32).init(allocator);
    defer url_map.deinit();

    var splits = split(u8, data, "\n");

    while (splits.next()) |line| {
        if (contains_link(line)) |url| {
            const existing_count = url_map.get(url) orelse 0;
            if (existing_count > 0) {
                std.debug.print("Duplicate link found: {s}\n", .{url});
            } else {
                try url_map.put(url, 1);
            }
        }
    }
}
// Function to extract the first URL from a Markdown line
fn contains_link(line: []const u8) ?[]const u8 {
    // Find the index of the opening bracket '['
    const open_bracket_idx = std.mem.indexOf(u8, line, "[");
    if (open_bracket_idx == null) return null; // No opening bracket, no link

    // Find the index of the closing bracket ']'
    const close_bracket_idx = std.mem.indexOf(u8, line[open_bracket_idx.? + 1 ..], "]");
    if (close_bracket_idx == null) return null; // No closing bracket, no link

    // Find the index of the opening parenthesis '(' after ']'
    const open_paren_idx = std.mem.indexOf(u8, line[open_bracket_idx.? + 1 + close_bracket_idx.? + 1 ..], "(");
    if (open_paren_idx == null) return null; // No opening parenthesis, no link

    // Find the index of the closing parenthesis ')'
    const close_paren_idx = std.mem.indexOf(u8, line[open_bracket_idx.? + 1 + close_bracket_idx.? + 1 + open_paren_idx.? + 1 ..], ")");
    if (close_paren_idx == null) return null; // No closing parenthesis, no link

    // Extract the URL between '(' and ')'
    const url_start = open_bracket_idx.? + close_bracket_idx.? + open_paren_idx.? + 3;
    const url_end = url_start + close_paren_idx.?; // The end index of the URL
    return line[url_start..url_end];
}

// Function to extract the first URL from a Markdown line
fn contains_link2(line: []const u8) ?[]const u8 {
    // Find the index of the opening bracket '['
    const open_bracket_idx = std.mem.indexOf(u8, line, "[");
    if (open_bracket_idx == null) return null; // No opening bracket, no link

    // Find the index of the closing bracket ']'
    const close_bracket_idx = std.mem.indexOf(u8, line[open_bracket_idx.? + 1 ..], "]");
    if (close_bracket_idx == null) return null; // No closing bracket, no link

    // Find the index of the opening parenthesis '(' after ']'
    const open_paren_idx = std.mem.indexOf(u8, line[open_bracket_idx.? + 1 + close_bracket_idx.? + 1 ..], "(");
    if (open_paren_idx == null) return null; // No opening parenthesis, no link

    // Find the index of the closing parenthesis ')'
    const close_paren_idx = std.mem.indexOf(u8, line[open_bracket_idx.? + 1 + close_bracket_idx.? + 1 + open_paren_idx.? + 1 ..], ")");
    if (close_paren_idx == null) return null; // No closing parenthesis, no link

    // Correct the start and end indices for extracting the URL
    const url_start = open_bracket_idx.? + close_bracket_idx.? + open_paren_idx.? + 1;
    const url_end = url_start + close_paren_idx.?;

    return line[url_start..url_end]; // Return the extracted URL
}
