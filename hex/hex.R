#Hex sticker creation from Eric Leung
# https://gist.github.com/erictleung/45924999e1c8d52142099c5faed8e2b7

# Make logo
library(hexSticker)
library(here)
library(showtext)

# Add Google Font
font_add_google(name = "Open Sans", family = "Open Sans")
showtext_auto() # Use this font in all rendering

# Picture of book that was quickly screenshot
imgurl <- here("hex", "logo_book.png")

sticker(
  imgurl,
  # Package settings
  package = "Big Book Of R",
  p_size = 19,
  p_y = 1.35,
  p_color = "#000000",
  p_family = "Open Sans",
  p_fontface = "bold",
  # Hexagon settings
  h_fill = "#EC4A81",
  h_color = "#000000",
  # Subplot or image settings
  s_x = 1,
  s_y = 0.75,
  s_width = 0.5,
  url = "BigBookofR.com",
  u_size = 10,
  filename = here("hex", "bigbookofrhex.png")
)
