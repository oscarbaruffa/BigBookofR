library(dplyr)
library(tidyr)
library(stringr)
library(googlesheets4)
library(readr)

# Deauthorize previous Google account credentials
gs4_deauth()

# Load data from Google Sheets
# Load data from Google Sheets
books_source <- read_sheet("https://docs.google.com/spreadsheets/d/1vufdtrIzF5wbkWZUG_HGIBAXpT1C4joPx2qTh5aYzDg", sheet = "books")
chapter_info <- read_sheet("https://docs.google.com/spreadsheets/d/1vufdtrIzF5wbkWZUG_HGIBAXpT1C4joPx2qTh5aYzDg/edit#gid=477753205", sheet="chapter_info")

# Arrange the book titles within each chapter
books_source <- books_source %>%
  separate_rows(chapters, sep = ";") %>%
  mutate(chapters = str_trim(chapters, side = "both")) %>%
  group_by(chapters) %>%
  arrange(title, .by_group = TRUE) %>%
  ungroup() %>%
  filter_all(any_vars(!is.na(.)))

# Get the list of unique chapters
chapters <- books_source %>%
  select(chapters) %>%
  distinct(chapters) %>%
  pull()

# Re-arrange specific chapters if needed
first_chapter <- "Career and Community"
last_chapter <- "Other compendiums"
chapters <- c(first_chapter, setdiff(chapters, c(first_chapter, last_chapter)), last_chapter)

# Generate .qmd files for each chapter
for (chapter in chapters) {
  chapter_content <- books_source %>%
    filter(chapters == chapter)
  
  # Start creating the content for the .qmd file
  qmd_content <- paste0("# ", chapter, "\n\n")
  
  # Add the introduction for the chapter
  if (chapter %in% chapter_info$chapters) {
    qmd_content <- paste0(qmd_content, chapter_info %>%
                            filter(chapters == chapter) %>%
                            pull(introduction), "\n")
  }
  
  # Loop through each entry in the chapter
  for (entry in seq_len(nrow(chapter_content))) {
    qmd_content <- paste0(qmd_content, "## ", chapter_content$title[entry], "\n\n")
    
    # Add authors
    authors_info <- c()
    for (i in 1:6) {
      author <- chapter_content[[paste0("author", i)]][entry]
      bio_link <- chapter_content[[paste0("bio", i)]][entry]
      if (!is.na(author) && !is.na(bio_link)) {
        authors_info <- c(authors_info, paste0("- [", author, "](", bio_link, ")"))
      } else if (!is.na(author)) {
        authors_info <- c(authors_info, paste0("- ", author))
      }
    }
    qmd_content <- paste0(qmd_content, paste(authors_info, collapse = "\n"), "\n\n")
    
    # Add other details
    if (!is.na(chapter_content$description[entry])) {
      qmd_content <- paste0(qmd_content, chapter_content$description[entry], "\n\n")
    }
    if (!is.na(chapter_content$paid[entry]) && !is.na(chapter_content$amount_usd[entry])) {
      qmd_content <- paste0(qmd_content, "Paid: ", chapter_content$paid[entry], " $", chapter_content$amount_usd[entry], "\n\n")
    }
    if (!is.na(chapter_content$link[entry])) {
      qmd_content <- paste0(qmd_content, "Link: [", chapter_content$link[entry], "](", chapter_content$link[entry], ")\n\n")
    }
    if (!is.na(chapter_content$physical[entry])) {
      qmd_content <- paste0(qmd_content, "Physical copy available: ", chapter_content$physical[entry], "\n\n")
    }
  }
  
  # Define the filename for the .qmd file
  file_name <- paste0("chapters/", gsub("[^[:alnum:] ]", "", chapter), ".qmd")
  
  # Write to the .qmd file
  writeLines(qmd_content, con = file_name)
}
