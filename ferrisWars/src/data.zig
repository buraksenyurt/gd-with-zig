const std = @import("std");

pub const PlayerScore = struct {
    id: u8,
    time: u64,
    score: u64,

    pub fn init(id: u8, time: u64, score: u64) @This() {
        return .{
            .id = id,
            .time = time,
            .score = score,
        };
    }

    pub fn compare(self: @This(), other: @This()) i32 {
        if (self.score > other.score) return -1;
        if (self.score < other.score) return 1;
        return 0;
    }
};

pub fn loadPlayerScores() ![10]PlayerScore {
    var scores: [10]PlayerScore = undefined;

    const fileContent = std.fs.cwd().readFileAlloc(std.heap.page_allocator, "scores.dat", 1024 * 1024) catch |err| {
        if (err == error.FileNotFound) return scores;
        return err;
    };
    defer std.heap.page_allocator.free(fileContent);

    var lineIterator = std.mem.splitScalar(u8, fileContent, '\n');
    var i: usize = 0;
    while (lineIterator.next()) |line| : (i += 1) {
        const lineString = std.mem.trim(u8, line, &std.ascii.whitespace);
        if (lineString.len == 0) continue;

        var fields = std.mem.splitScalar(u8, lineString, ',');
        const idField = fields.next();
        const elapsedTimeField = fields.next();
        const scoreField = fields.next();

        if (elapsedTimeField) |t_str| {
            if (scoreField) |s_str| {
                const id = std.fmt.parseInt(u8, std.mem.trim(u8, idField orelse "", &std.ascii.whitespace), 10) catch continue;
                const time = std.fmt.parseInt(u64, std.mem.trim(u8, t_str, &std.ascii.whitespace), 10) catch continue;
                const score = std.fmt.parseInt(u64, std.mem.trim(u8, s_str, &std.ascii.whitespace), 10) catch continue;

                scores[i] = PlayerScore.init(id, time, score);
                if (i >= 9) break;
            }
        }
    }

    return scores;
}

pub fn savePlayerScores(scores: []PlayerScore) !void {
    // std.debug.print("Saving player scores...\n{any}", .{scores});

    var file = try std.fs.cwd().createFile(
        "scores.dat",
        .{ .truncate = true },
    );
    defer file.close();

    for (scores) |s| {
        const line = try std.fmt.allocPrint(std.heap.page_allocator, "{},{},{}\n", .{ s.id, s.time, s.score });
        defer std.heap.page_allocator.free(line);

        try file.writeAll(line);
    }
}
