library(magick)

image_paths <- list.files(
  "man/figures",
  pattern = "screenshot-vignette-.*.png",
  full.names = TRUE
)

img_cover    <- image_read(image_paths[1])
img_contents <- image_read(image_paths[2])
img_notes    <- image_read(image_paths[3])
img_table    <- image_read(image_paths[4])

images <- c(
  img_cover,
  img_contents,
  img_notes,
  img_table
)

animation <- image_animate(images, fps = 1, dispose = "previous")

image_write(animation, "man/figures/vignette-workbook.gif")
