
echo '提交版本记录'
git add .
git commit -m  'update'

echo '开始编译成静态包'
pod package HBTesterKit.podspec  --force
echo '编译完成'
#echo '拷贝到目标目录'




