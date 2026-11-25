# CV Flutter Phil

Application mobile Flutter de présentation d'un CV, d'une famille et de
coordonnées. L'interface est en français et comporte une page de connexion,
puis une navigation entre les pages **Mon CV**, **Famille** et **Contact**.

## Lancer l'application

```shell
flutter pub get
flutter run
```

La connexion utilise les comptes de l’API ; créez d’abord un compte avec
`POST /accounts/register` (voir le README du projet API).

## Connexion à l’API

L’application utilise l’API PHP décrite dans
[`espoirbaraka/api-test`](https://github.com/espoirbaraka/api-test). Elle charge
les membres depuis `/famille-membres` et permet de les ajouter, modifier et
supprimer. Les informations du CV et les coordonnées restent locales, car
l’API ne fournit pas de routes pour ces données.

Par défaut, l’URL est `http://localhost/api-test/public`. Pour l’émulateur
Android, `localhost` désigne l’émulateur lui-même : utilisez l’adresse spéciale
de l’hôte avec :

```shell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2/api-test/public
```

Sur un appareil physique, remplacez `10.0.2.2` par l’adresse IP locale de
l’ordinateur qui exécute XAMPP. Les builds debug/profile autorisent HTTP pour
le serveur local ; les builds de production doivent utiliser HTTPS.

Les profils, photos et coordonnées affichés sont des exemples fictifs.
Remplacez-les dans `lib/main.dart` par les informations souhaitées avant de
publier l'application.

## Vérification

```shell
flutter test
flutter analyze
```
