start:
	hexo clean && hexo generate && hexo server
	@echo "Hexo start"

deploy:
	hexo clean && hexo deploy
	@echo "Hexo deploy"