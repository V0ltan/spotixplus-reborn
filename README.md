# SpotiX+ Reborn Windows

### Qu'est-ce que SpotiX+ Reborn ?
Il s'agit d'une version modifiée de Spotify, vous permettant de ne plus avoir de pub, passer les titres à l'infini, et bien plus encore !

Originalement créé par Voltan, SpotiX+ n'est malheureusement plus en développement\
Nous avons donc décidé de prendre le relais, ainsi fut né SpotiX+ Reborn

### Téléchargements et installation
Rendez-vous sur la section [Releases](https://github.com/DelofJ/spotixplus-windows/releases) pour pouvoir télécharger la dernière version du programme\
Téléchargez et lancez le fichier `script.ps1`\
Il vous faudra PowerShell 7 pour lancer ce script\
Si vous ne l'avez pas d'installé, vous pourrez le lancer avec PowerShell 5 installé de base sur Windows et le script vous fera automatiquement installer PowerShell 7

### Bugs connus
Si vous avez le message suivant qui apparait :
```
File <chemin>\script.ps1 cannot be loaded because running scripts is disabled on this system
```
Ouvrez PowerShell, entrez la commande suivante :
```
Set-ExecutionPolicy ByPass -Force
```
Vous devriez être capable de lancer le script désormais 

### J'ai d'autres bugs
Regardez si quelqu'un n'a pas déjà reporté le bug dans l'onglet [Issues](https://github.com/DelofJ/spotixplus-windows/issues) ou sur le Discord\
Si c'est le cas, envoyer une réponse en disant que cela vous arrive aussi\
Sinon, reportez-le vous même
