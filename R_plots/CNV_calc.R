library (dplyr)

Clone2 <- Clone2 %>% select(gene, log2)
names(Clone2) <- c("gene", "Clone2")

Clone3<- Clone3 %>% select(gene, log2)
names(Clone3) <- c("gene", "Clone3")

Clone4 <- Clone4 %>% select(gene, log2)
names(Clone4) <- c("gene", "Clone4")

Clone5 <- Clone5 %>% select(gene, log2)
names(Clone5) <- c("gene", "Clone5")

ST <- CloneST %>% select(gene, log2)
names(ST) <- c("gene", "ST")

FI <- CloneFI %>% select(gene, log2)
names(FI) <- c("gene", "FI")

experiment <- left_join(Clone2, Clone3, by = c("gene"))
experiment <- left_join(experiment, FI, by = c("gene"))

write.csv(experiment, file = "copy_variants.csv")
