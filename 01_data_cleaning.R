###############################################
### 2025 data cleaning program for raffle
### GOALS:
###     1. Clean data from non-profit partner
###     2. Output one frame per ticket type
###############################################

library(openxlsx)
library(dplyr)

#### Readin data
readpath <- "C:/Users/megan/Documents/Programming/Raffle project/"
writepath <- paste0(readpath, "out/")

### Load in data
initial_file <- read.xlsx(paste0(readpath, "Company Raffle Results.xlsx")) %>%
  # minimal cleaning
  # shortening names for tab output
  mutate(Ticket.Name = case_when(Ticket.Name == "Custom Walnut Charcuterie Board" ~ "Custom Charcuterie Board", 
                                 Ticket.Name == "Indian Cooking Fundamentals with [Colleague Name Redacted]" ~ "Indian Cooking Fundamentals", 
                                 Ticket.Name == "Meta Quest Headset and Controllers" ~ "Meta Quest", 
                                 Ticket.Name == "Private Yoga Class with a Senior Instructor" ~ "Private Yoga Class", 
                                 .default = Ticket.Name))

### Create one frame per ticket type
### First select ticket types
type_of_raffle <- initial_file %>%
  select(Ticket.Name) %>%
  distinct()

### Initialize prize book; populate
prize_book <- list()
for (i in type_of_raffle$Ticket.Name){
  subset_dta <- initial_file %>%
    filter(Ticket.Name == i)
  
  prize_book[[i]] <- subset_dta
}

names(prize_book) <- type_of_raffle$Ticket.Name

### Output for human review
write.xlsx(prize_book, file = paste0(writepath, "cleaned_raffle.xlsx"))
### Output for program use
save(prize_book, file = paste0(writepath, "cleaned_raffle.RData"))