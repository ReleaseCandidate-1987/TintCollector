function linearize(channel) {
    channel /= 255;
    return channel <= 0.04045
        ? channel / 12.92
        : Math.pow((channel + 0.055) / 1.055, 2.4);
}

function collectColors(pixels) {
    const colors = new Map();

    for (let index = 0; index < pixels.length; index += 4) {
        const alpha = pixels[index + 3];
        if (alpha === 0)
            continue;

        const red = pixels[index];
        const green = pixels[index + 1];
        const blue = pixels[index + 2];
        const color = "#" + [alpha, red, green, blue]
            .map(channel => channel.toString(16).padStart(2, "0")).join("");

        if (!colors.has(color)) {
            colors.set(color, {
                color: color,
                brightness: 0.2126 * linearize(red)
                          + 0.7152 * linearize(green)
                          + 0.0722 * linearize(blue)
            });
        }
    }

    return Array.from(colors.values());
}

function selectColors(colors) {
    colors.sort((left, right) => left.brightness - right.brightness);
    const count = Math.min(15, colors.length);

    return Array.from({ length: count }, (_, index) => {
        const position = Math.round(index * (colors.length - 1) / Math.max(1, count - 1));
        return colors[position].color;
    });
}

WorkerScript.onMessage = function(message) {
    try {
        const colors = selectColors(collectColors(message.pixels));
        WorkerScript.sendMessage({ colors: colors });
    } catch (error) {
        WorkerScript.sendMessage({ colors: [], error: String(error) });
    }
};
