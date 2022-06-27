# 部署到 github pages 脚本
# 错误时终止脚本
set -e

# 删除打包文件夹
rm -rf public

# 打包。
hugo -t LoveIt # if using a theme, replace with `hugo -t <YOURTHEME>`

# 进入打包文件夹
cd public

# Add changes to git.

git init
git add -A

# Commit changes.
msg="building site $(date)"
if [ $# -eq 1 ]; then
  msg="$1"
fi
git commit -m "$msg"

git push origin main

# 回到原文件夹
cd ..
