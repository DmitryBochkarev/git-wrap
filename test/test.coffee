Git = require '../'
git = Git './'

# git.head console.log
# git.heads console.log
# git.history console.log
# git.object "8f168a3885b33b050044014de1f7b3cd74d513a8", console.log
# git.object "505adae098570ac622551142d76ac9577ae05430", console.log
# git.lsTree 'master', console.log
git.objectByPath 'master', 'test', console.log
git.objectByPath 'master', 'test/test.coffee', console.log
git.objectByPath 'test', 'test/test.coffee', console.log

