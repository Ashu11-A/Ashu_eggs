</div>
<div align="center">

# Paper (Super-Optimized)

</div>

## 📃 | Description
Here is the explanation about the optimizations that this Egg contains...

Remember, optimized doesn't mean less RAM usage, on the contrary, starting from 4GB of RAM, it will use the maximum to make the garbage collector work properly.

Sources used to create this Egg:   
https://www.spigotmc.org/threads/guide-server-optimization%E2%9A%A1.283181/   
https://shockbyte.com/billing/knowledgebase/153/Optimizing-spigotyml-to-Reduce-Lag.html   
https://shockbyte.com/billing/knowledgebase/154/Optimizing-bukkityml-to-Reduce-Lag.html   
https://shockbyte.com/billing/knowledgebase/155/Optimize-paperyml-to-Reduce-Lag.html   
https://cassiofernando.netlify.app/blog/minecraft-argumentos-java   
https://docs.papermc.io/paper/aikars-flags   

Azul Zulu:   
https://docs.azul.com/prime/what-to-expect   
https://github.com/Software-Noob/pterodactyl-images   

</div>
<div align="center">

## Optimizations

</div>

## 🐳 | Docker

The Docker being used by this Egg is called Azul Zulu. It is known for its low latency, high performance, and efficient garbage collector.

## 🗂 | Files

### 📄 | bukkit.yml

| Variable | Original | Modified | Learn more |
|--|--|--|--|
| monsters | 70 | 50 | Limit of monsters. |
| animals | 10 | 8 | Limit of animals. |
| water-animals | 5 | 3 | Limit of aquatic animals. |
| ambient | 15 | 1 | Limit of ambient creatures (such as bats). |
| period-in-ticks | 600 | 400 | Frequency at which the garbage collection system cleans up unused parts. |
| monster-spawns | 1 | 2 | Determines the waiting time between monster spawns. |

### 📄 | paper-world-defaults.yml

| Variable | Original | Modified | Learn more |
|--|--|--|--|
| max-auto-save-chunks-per-tick | 24 | 8 | Maximum number of chunks saved per tick. |
| prevent-moving-into-unloaded-chunks | false | true | Players can move on unloaded blocks. |
| max-entity-collisions | 8 | 2 | Stops processing collisions after this value is reached. |
| disable-chest-cat-detection | false | true | Open chests even if a cat is sitting on top of them. |
| creative-arrow-despawn-rate | default | 180 | The rate at which arrows shot by players in creative mode are despawned. |
| non-player-arrow-despawn-rate | default | 180 | The rate at which arrows shot by non-player entities are despawned. |
| disable-move-event | false | true | Disables ```InventoryMoveItemEvent```. Dramatically improves hopper performance but may break some plugins that rely on this variable. |
| allow-non-player-entities-on-scoreboards | true | false | Slightly reduces the amount of time the server spends calculating entity collisions. |
| keep-spawn-loaded-range | 10 | 8 | The value of chunks around spawn to keep loaded. |
| container-update | 1 | 2 | The rate at which the server updates containers (chests, furnaces...) and inventories. |
| grass-spread | 1 | 2 | Sets the delay at which the server tries to spread grass. |
| mob-spawner | 1 | 2 | Sets the frequency of entity spawn calculations by mob spawners in the world. |

### 📄 | spigot.yml

| Variable | Original | Modified | Learn more |
|--|--|--|--|
| item | 2.5 | 4.0 | Items will group together more often, reducing the number of items on the ground. |
| exp | 3.0 | 6.0 | Experience orbs will group together more often, reducing the number of items on the ground. |
| mob-spawn-range | 8 | 6 | The distance in chunks from the player for mobs to be spawned. |
| arrow-despawn-rate | 1200 | 300 | Arrows shot by players in survival mode will disappear more quickly per ticks (300 = 15s). |
| nerf-spawner-mobs | false | true | Mobs spawned by spawners won't have AI. |
| animals | 32 | 16 | How close a mob needs to be to activate its AI. |
| monsters | 32 | 24 | How close a mob needs to be to activate its AI. |
| misc | 16 | 8 | How close a mob needs to be to activate its AI. |
| tile | 50 | 1000 | Due to the risk involved with enabling this feature, set it to 1000, effectively disabling the feature. |
| entity | 50 | 1000 | Due to the risk involved with enabling this feature, set it to 1000, effectively disabling the feature. |

### 📄 | server.properties

| Variable | Original | Modified | Learn more |
|--|--|--|--|
| network-compression-threshold | 256 | 512 | Limits the size of a packet before compressing it. Setting it higher can save some resources at the cost of bandwidth. |

## ⚙️ | Startup

| Optimization | Variable |
|--|--|
| (0) Geral | ```java -Xms128M -Xmx${SERVER_MEMORY}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}``` |
| (1) 1GB RAM | ```java -Xmx1G -Xms1G -Xmn128m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat  -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}``` |
| (2) 2GB RAM | ```java -Xms2G -Xmx2G -Xmn384m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat  -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}``` |
| (3) 3Gb RAM | ```java -Xms3G -Xmx3G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat  -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}``` |
| (4) 4+Gb RAM | ```java -Xms3584M -Xmx4G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat  -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -jar ${SERVER_JARFILE}``` |
| (5) 4GB RAM / 4threads / 4cores | ```java -Xms2G -Xmx2G -Xmn384m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UseCompressedOops -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=4 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE}``` |
| (6) 8+GB RAM / 8threads / 4cores | ```java -Xms4G -Xmx4G -Xmn512m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE}``` |
| (7) 12+GB RAM | ```java -Xms11G -Xmx12G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}``` |
