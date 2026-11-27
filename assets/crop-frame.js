// Crops the demo frame out of a full-page screenshot: crop-frame.js <landing> <in> <out>.
// The frame has a 1px border in the line colour (#2F2A33). Its top and bottom edges are
// the first and last rows holding a horizontal run of that colour about as wide as the
// frame (2000-2400 device px), which skips the install box (narrower) and full-width
// section dividers (wider). Left and right are the outermost border pixels on the frame's middle row,
// since the rounded corners shorten the top edge's run.
const sharp = require(process.argv[2] + '/node_modules/sharp');

(async () => {
  const { data, info } = await sharp(process.argv[3]).raw().toBuffer({ resolveWithObject: true });
  const { width, height, channels } = info;
  const border = [0x2f, 0x2a, 0x33];
  const isBorder = (x, y) => {
    const i = (y * width + x) * channels;
    return data[i] === border[0] && data[i + 1] === border[1] && data[i + 2] === border[2];
  };
  let top = -1, bottom = -1;
  for (let y = 0; y < height; y++) {
    let best = 0, run = 0;
    for (let x = 0; x <= width; x++) {
      if (x < width && isBorder(x, y)) run++;
      else {
        if (run > best) best = run;
        run = 0;
      }
    }
    if (best >= 2000 && best <= 2400) {
      if (top < 0) top = y;
      bottom = y;
    }
  }
  if (top < 0 || bottom <= top) {
    console.error('could not find the demo frame in the page screenshot');
    process.exit(1);
  }
  if (bottom >= height - 2) {
    console.error('the demo frame runs off the bottom of the screenshot');
    process.exit(1);
  }
  const mid = Math.round((top + bottom) / 2);
  let left = 0, right = width - 1;
  while (left < width && !isBorder(left, mid)) left++;
  while (right > left && !isBorder(right, mid)) right--;
  await sharp(process.argv[3])
    .extract({ left, top, width: right - left + 1, height: bottom - top + 1 })
    .removeAlpha()
    .toFile(process.argv[4]);
})();
