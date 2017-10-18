# Assumes the scripts from Rmarkdown file are already run

top.left <- data.frame(x.dashed = 0:(length(res_i_certain) - 1),
                       y.dashed = res_i_certain,
                       x.solid = 0:(length(res_i_uncertain) - 1),
                       y.solid = res_i_uncertain)

plot(x = top.left$x.dashed, y = top.left$y.dashed, ylim = c(0,1))
plot(x = top.left$x.solid, y = top.left$y.solid, ylim = c(0,1))

top.right <- data.frame(x.dashed = 0:(length(res_iv_certain) - 1),
                        y.dashed = res_iv_certain,
                        x.solid = 0:(length(res_iv_uncertain) - 1),
                        y.solid = res_iv_uncertain)
plot(x = top.right$x.dashed, y = top.right$y.dashed, ylim = c(0,1))
plot(x = top.right$x.solid, y = top.right$y.solid, ylim = c(0,1))

bottom.left <- data.frame(x.dashed = seq(0, 1, .01),
                          y.dashed.lb = (res_i_certain_lb / N_I) * 100,
                          y.dashed.ub = (res_i_certain_ub / N_I) * 100,
                          x.solid = seq(0, 1, .01),
                          y.solid.lb = (res_i_uncertain_lb / N_I) * 100,
                          y.solid.ub = (res_i_uncertain_ub / N_I) * 100) 

plot(x = bottom.left$x.dashed, y = bottom.left$y.dashed.lb, ylim = c(0, 100))
lines(x = bottom.left$x.dashed, y = bottom.left$y.dashed.ub, ylim = c(0, 100))
plot(x = bottom.left$x.solid, y = bottom.left$y.solid.lb, ylim = c(0, 100))
lines(x = bottom.left$x.solid, y = bottom.left$y.solid.ub, ylim = c(0, 100))


bottom.right <- data.frame(x.dashed = seq(0, 1, .01),
                           y.dashed.lb = (res_iv_certain_lb / N_IV) * 100,
                           y.dashed.ub = (res_iv_certain_ub / N_IV) * 100,
                           x.solid = seq(0, 1, .01),
                           y.solid.lb = (res_iv_uncertain_lb / N_IV) * 100,
                           y.solid.ub = (res_iv_uncertain_ub / N_IV) * 100)

plot(x = bottom.right$x.dashed, y = bottom.right$y.dashed.lb, ylim = c(0, 100))
lines(x = bottom.right$x.dashed, y = bottom.right$y.dashed.ub, ylim = c(0, 100))
plot(x = bottom.right$x.solid, y = bottom.right$y.solid.lb, ylim = c(0, 100))
lines(x = bottom.right$x.solid, y = bottom.right$y.solid.ub, ylim = c(0, 100))

write.csv(top.left, file = '../data/ploty_top.left.csv', row.names = FALSE)
write.csv(top.right, file = '../data/ploty_top.right.csv', row.names = FALSE)
write.csv(bottom.left, file = '../data/ploty_bottom.left.csv', row.names = FALSE)
write.csv(bottom.right, file = '../data/ploty_bottom.right.csv', row.names = FALSE)
