import '../models/collection.dart';

const List<CollectionItem> initialCollections = [
  CollectionItem(
    id: 'col-1',
    name: 'Para ella',
    description: 'Palabras sinceras para dedicar en cualquier momento',
    phraseIds: ['1', '5', '33', '97'],
    createdAt: '2026-09-01',
    coverPhraseId: '1',
  ),
  CollectionItem(
    id: 'col-2',
    name: 'Mis favoritas',
    description: 'Las frases que más resuenan en mi corazón',
    phraseIds: ['3', '65', '129', '161'],
    createdAt: '2026-08-28',
    coverPhraseId: '3',
  ),
  CollectionItem(
    id: 'col-3',
    name: 'Buenos días y noches',
    description: 'Para empezar y terminar el día con amor',
    phraseIds: ['161', '165', '193', '197'],
    createdAt: '2026-09-03',
    coverPhraseId: '161',
  ),
];
