source("./R/practice-info201.R")

practice.begin()
practice.answers()
# practice.questions()
t_01 <- 27
num <- 111 / 9
t_03 <- (1 + 17 + 19 + 31) / 4
t_04 <- 2^20
t_04 <- (-5 + -10 + -12) / 3
circle_area <- function(r) {return(pi*r^2)}
practice.check()

practice.check()

t <- formals(circle_area_Check)
v <- names(t)
length(v)

vpaste0(v, collpase=", ")



length(t)
v <- c()
for (k in 1:length(t)) {
  v <- append(v,t[k])
}
print(v)
length(v)

typeof(v)
