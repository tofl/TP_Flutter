# Application d'affichage de gifs

Il s'agit d'une application mobile qui permet de rechercher des gifs à partir de mots-clefs. Les gifs sont ensuite affichés sur une liste en _vertical wrap_ (waterfall flow).

## Utilisation
L'utilisation est très simple :
1. L'application s'ouvre sur une page de recherche légèrement inspirée de Google.
2. L'utilisateur tape sa recherche, puis est redirigé vers la page des résultats.
3. L'utilisateur peut revenir à la page précédente ou se servir du formulaire de recherche en haut de la page des résultats, afin de faciliter la navigation.
4. Toucher une image permet de l'afficher en grand.
5. Maintenir son doigt appuyé sur une image permet d'ouvrir le meu de partage et téléchargement.

## Technologie
L'application a été codée avec Flutter.



**Recherche de gifs**

L'API utilisée pour la récupération de gifs est Giphy.



**Routage**

Cette application utilise des routes nommées pour la navigation.



**Affichage des résultats de recherche**

Les résultats de recherche sont affichés grâce au plugin `waterfall_flow`, qui permet de faire un wrap vertical (aussi appelé _waterfall layout_). Malheureusement, il s'agit du seul composant qui permet de réaliser un tel affichage, et sa documentation très médiocre ne permet pas de l'utiliser simplement.

Les composants affichés par les widgets offerts par ce plugin étant des images provenant d'Internet et obligeant un temps de chargement (asynchrone), il était impossible de déterminer (de façon simple et intuitive) si l'utilisateur avait scrollé tout en bas de la liste en vue de charger les images suivantes. En effet, le widget `WaterfallFlow` considère que l'utilisateur a atteint la fin de la liste lorsque les images ne sont pas encore chargées sur l'écran. Ainsi, il n'était pas possible d'émettre une requête pour créer de la pagination automatique (afficher les gifs suivants lorsque l'utilisateur arrive en fin de liste). Cela avait pour conséquence de démultiplier les requêtes émises. Pour résoudre ce problème, il aurait été nécessaire de mettre en place une logique bien plus complexe qui aurait permit de déterminer lorsque l'utilisateur a réellement atteint la fin de la liste.



## Améliorations possibles

1. Pour des raisons de sécurité, il ne faut pas stocker de secrets dans le code source de l'app Flutter. Il aurait donc fallu créer un proxy afin de masquer la clef d'aurhentification de l'API Giphy.
2. Système de pagination : l'objectif de créer une pagination automatique n'a pas été atteint en raison de la limitation du widget `waterfall_flow`. La pagination pourrait être faite manuellement en contrepartie.
3. Système de favoris/likes.
4. Restructuration du code : il existe une variable dans le fichier `GifsPage.gif` à laquelle est affecté le widget à afficher sur la page (un texte 'loading' si les images n'ont pas été retrouvées, ou la liste des images dans le cas contraire). Afin d'alléger ce fichier, il aurait été utile de déplacer le widget `WaterfallFlow` dans un fichier qui lui est propre.