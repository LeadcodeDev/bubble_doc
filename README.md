# Bubble Documentation

## Motivation
Il existe une multitude d'outils permettant de concevoir des documentations tels que [Undocs](https://undocs.pages.dev), [VitePress](https://vitepress.dev), [Docusaurus](https://docusaurus.io) ou encore [Docs-boilerplate](https://github.com/dimerapp/docs-boilerplate) utilisé pour l'ensemble des packages d'Adonis.
Le problème à l'exception du boilerplater d'Adonis est qu'ils utilisent tous un framework/librairie frontend qui à mon sens n'est pas nécessaire pour la conception d'une documentation.

Lorsque nous parlons de documentation et ainsi d'une approche "content first", nous pensons directement au framework [Astro](https://astro.build/) qui promet une génération de documents statiques depuis des fichiers markdown relativement effeciente; cependant cet outil n'est pas conçu pour être utilisé pleinement dans le cadre de la documentation d'un projet.

C'est pourquoi j'ai décidé de créer Bubble, un outil permettant de générer une documentation à partir de fichiers markdown sans avoir besoin d'utiliser un framework frontend.

### Choix de la technologies

En tant que grand adepte du langage Dart, j'ai décidé de créer Bubble en utilisant le langage Dart afin de profiter de sa vitesse génération de contenu lors de la phase de build.

> [!NOTE]
> Bubble permet de générer plus de pages qu'Astro 👀

## Installation
L'installation de Bubble est très simple, il suffit d'utiliser ce repository comme [template](https://github.com/new?template_name=bubble_doc&template_owner=LeadcodeDev) pour votre projet.

Une fois fait, il vous suffit de lancer la commande suivante pour installer les dépendances:
```bash
dart pub get
```
