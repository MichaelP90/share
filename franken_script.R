# install.packages("maptools")
# install.packages("rgeos")
# install.packages("tidyverse")
# install.packages("sp")
# install.packages("rgdal")
# install.packages("broom")
# install.packages("cowplot")
 
library(tidyverse)
library(sp)
library(rgdal)
library(broom)
library(readxl)
library(cowplot)

readRDS("S:/Tausch/PorstM/kreise_bkg2.rds") %>% 
    mutate(kkz = as.numeric(id)) -> shapefile
load("S:/Tausch/PorstM/Covid_Faelle_02062020.RData")

Cov19_ag %>% filter(Todesfall == "Nein") -> data


Cov19_ag %>% group_by(Todesfall) %>% summarise(summe = sum(x))
read_csv2("S:/Tausch/PorstM/INKAR_Daten.csv") %>% 
    mutate(kkz = as.numeric(Kennziffer)) -> inkar

left_join(shapefile, data, by = "kkz") %>% 
    left_join(inkar, by = "kkz")-> merged_data

merged_data$doctors <- merged_data$`Ärzte je  Einwohner`

# Verhältnisse bilden
merged_data %>% 
    mutate(ind1 = x / doctors,
           ind2 = x / Einpendler,
           ind3 = x / Auspendler,
           ind4 = x / Krankenhausbetten) -> merged_data





p1 <- ggplot(data = merged_data) +
    geom_polygon(aes(x=long,y=lat, group=group, fill = x), colour = "white") + 
    coord_equal() + 
    theme_void() + 
    scale_fill_viridis_c(option = "magma", direction = -1)

p2 <- ggplot(data = merged_data) +
    geom_polygon(aes(x=long,y=lat, group=group, fill = ind1), colour = "white") + 
    coord_equal() + 
    theme_void() + 
    scale_fill_viridis_c(option = "magma", direction = -1)

p3 <- ggplot(data = merged_data) +
    geom_polygon(aes(x=long,y=lat, group=group, fill = ind2), colour = "white") + 
    coord_equal() + 
    theme_void() + 
    scale_fill_viridis_c(option = "magma", direction = -1)

p4 <- ggplot(data = merged_data) +
    geom_polygon(aes(x=long,y=lat, group=group, fill = ind3), colour = "white") + 
    coord_equal() + 
    theme_void() + 
    scale_fill_viridis_c(option = "magma", direction = -1)

p5 <- ggplot(data = merged_data) +
    geom_polygon(aes(x=long,y=lat, group=group, fill = ind4), colour = "white") + 
    coord_equal() + 
    theme_void() + 
    scale_fill_viridis_c(option = "magma", direction = -1)

plot_grid(p1, p2, p3, p4, p5, ncol = 2)
