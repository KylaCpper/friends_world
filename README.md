# friends_world
这是一个个人的游戏项目，详细介绍 在 https://space.bilibili.com/812899?spm_id_from=333.1007.0.0
因为切换到unity 所以此项目已经废弃。
用项目里面的编辑器可以打开项目。是 godot.windows.opt.tools.32.3.3.3.exe
godot 3.33 版本 编译了godot voxel 

主要文件介绍
*   config:
*     composite:合成表的数据
*       composite_big.json:合成表的分类数据
*       composite_small.json:合成表每个分类能合成数据
*       furnace.json:熔炉的合成表相关
*     default:默认的物品详细数据 数据驱动 名 贴图 重量 工具类型 食物 方向 摔落类型 掉落 合成方式等等
*     其他：剩下的是每个分类下的物品详细数据
* 
*   global：里面是全局单例
*   lib:第三方库
*   scene:场景文件
*     cg：开头动画场景
*     main:游戏主场景
*     start:开始页面场景
*   script:功能方块物品脚本文件
*     里面是个个分类的方块和物品的自定义功能脚本
*   tscn：预制件
*     animal：动物类独立预制件 骨骼动画脚本模型统一放入
*     audio：主控制音频的预制件
*     block：
*       fall：掉落方块的脚本及预制件
*       select：选中的显示方块预制件
*       single：拿在手上以及掉落，独立显示的方块预制件
*       character：玩家和npc和的模型脚本动画骨骼
*         player_client：客户端用玩家预制件
*         player：主机用玩家预制件
*       control：手机端移动预制件
*       drop：丢出的方块预制件
*       item：非体素方块类型的独立模型
*       msg：聊天气泡预制件
*       particle：粒子类
*       shader：常用shader ui
*       ui：里面为ui的个个预制件
*       world：
*         generator：里面为地形生成器脚本
*     
编辑器的地址：https://github.com/KylaCpper/friends-world-editor
![alt](/img22.png)
