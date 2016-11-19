#remove row with "bacteria" 
plot(tab2$U2_CD01190_1_res, tab2$XT_CD01190_1_res)
lines(x = c(0,100), y = c(0,100))


plot(tab$U2_CD01190_1_res, tab$XT_CD01190_1_res)
lines(x = c(0,100), y = c(0,100))


pdf("CD01190.pdf",width=6,height=4,paper='special')
xlim <- c(0,.4); ylim <- c(0,.4)
p<-ggplot(tab,aes(U2_CD01190_1_res,XT_CD01190_1_res))
p.full <- p + geom_point() + geom_abline(intercept=0) + ggtitle("CD01190") + labs(x="U2", y="XT")
  # zoomed plot
  p.zoom <- ggplot(tab,aes(U2_CD01190_1_res,XT_CD01190_1_res)) + geom_point() + coord_cartesian(xlim=xlim, ylim=ylim) + geom_abline(intercept=0) + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
  # put them together
  g <- ggplotGrob(p.zoom)
  p.full + annotation_custom(grob = g, xmin = 60, xmax =100, ymin =0, ymax = 50)
dev.off()




plot(tab$U2_RC00462_1_res, tab$XT_RC00462_1_res)

pdf("RC00462.pdf",width=6,height=4,paper='special')
xlim <- c(0,1); ylim <- c(0,1)
p<-ggplot(tab,aes(U2_RC00462_1_res,XT_RC00462_1_res))
p.full <- p + geom_point() + geom_abline(intercept=0) + ggtitle("RC00462") + labs(x="U2", y="XT")
  # zoomed plot
  p.zoom <- ggplot(tab,aes(U2_RC00462_1_res,XT_RC00462_1_res)) + geom_point() + coord_cartesian(xlim=xlim, ylim=ylim) + geom_abline(intercept=0) + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
  # put them together
  g <- ggplotGrob(p.zoom)
  p.full + annotation_custom(grob = g, xmin = 0, xmax = 50, ymin = 52, ymax = 100)
dev.off()


plot(tab$U2_CD01465_1_res, tab$XT_CD01465_1_res)

pdf("CD01465.pdf",width=6,height=4,paper='special')
xlim <- c(0,4.5); ylim <- c(0,4.5)
p<-ggplot(tab,aes(U2_CD01465_1_res,XT_CD01465_1_res))
p.full <- p + geom_point() + geom_abline(intercept=0) + ggtitle("CD01465") + labs(x="U2", y="XT")
  # zoomed plot
  p.zoom <- ggplot(tab,aes(U2_CD01465_1_res,XT_CD01465_1_res)) + geom_point() + coord_cartesian(xlim=xlim, ylim=ylim) + geom_abline(intercept=0) + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
  # put them together
  g <- ggplotGrob(p.zoom)
  p.full + annotation_custom(grob = g, xmin = 0, xmax = 50, ymin = 52, ymax = 100)
dev.off()


plot(tab$U2_RC00189_1_res, tab$XT_RC00189_1_res)
pdf("RC00189.pdf",width=6,height=4,paper='special')
xlim <- c(0,3.5); ylim <- c(0,3.5)
p<-ggplot(tab,aes(U2_RC00189_1_res,XT_RC00189_1_res))
p.full <- p + geom_point() + geom_abline(intercept=0) + ggtitle("RC00189") + labs(x="U2", y="XT")
  # zoomed plot
  p.zoom <- ggplot(tab,aes(U2_RC00189_1_res,XT_RC00189_1_res)) + geom_point() + coord_cartesian(xlim=xlim, ylim=ylim) + geom_abline(intercept=0) + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
  # put them together
  g <- ggplotGrob(p.zoom)
  p.full + annotation_custom(grob = g, xmin = 0, xmax = 50, ymin = 52, ymax = 100)
dev.off()





plot(tab$U2_CD01500_1_res, tab$XT_CD01500_1_res)
pdf("CD01500.pdf",width=6,height=4,paper='special')
xlim <- c(0,.2); ylim <- c(0,.2)
p<-ggplot(tab,aes(U2_CD01500_1_res,XT_CD01500_1_res))
p.full <- p + geom_point() + geom_abline(intercept=0) + ggtitle("CD01500") + labs(x="U2", y="XT")
  # zoomed plot
  p.zoom <- ggplot(tab,aes(U2_CD01500_1_res,XT_CD01500_1_res)) + geom_point() + coord_cartesian(xlim=xlim, ylim=ylim) + geom_abline(intercept=0) + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
  # put them together
  g <- ggplotGrob(p.zoom)
  p.full + annotation_custom(grob = g, xmin = 0, xmax = 50, ymin = 52, ymax = 100)
dev.off()



