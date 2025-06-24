## 最新设备开发：

安装hexo-cli
```bash
npm install -g hexo-cli
```

加入bufferfly theme
```bash
git clone -b master https://gitee.com/immyw/hexo-theme-butterfly.git themes/butterfly
```

安装plugin
```bash
npm install hexo-renderer-pug hexo-renderer-stylus --save
```

部署：
```bash
hexo clean //执行此命令后继续下一条
hexo g //生成博客目录
hexo s //本地预览
hexo d // 部署到github
```

