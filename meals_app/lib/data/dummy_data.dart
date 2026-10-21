import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/meal.dart';

const availableCategories = <Category>[
  Category(id: 'c1', title: 'Talianske', color: Colors.purple),
  Category(id: 'c2', title: 'Rýchle a jednoduché', color: Colors.red),
  Category(id: 'c3', title: 'Hamburgery', color: Colors.orange),
  Category(id: 'c4', title: 'Nemecké', color: Colors.amber),
  Category(id: 'c5', title: 'Ľahké a zdravé', color: Colors.green),
  Category(id: 'c6', title: 'Exotické', color: Colors.teal),
  Category(id: 'c7', title: 'Raňajky', color: Colors.blue),
  Category(id: 'c8', title: 'Ázijské', color: Colors.pink),
];

const dummyMeals = <Meal>[
  Meal(
    id: 'm1', categories: ['c1', 'c2'], title: 'Špagety s paradajkovou omáčkou',
    imageUrl: 'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?w=1000',
    ingredients: ['200 g špagiet', '400 g paradajok', '1 strúčik cesnaku', 'Olivový olej', 'Bazalka', 'Soľ a korenie'],
    steps: ['Uvarte špagety v osolenej vode podľa návodu.', 'Na panvici zohrejte olivový olej a krátko opečte nasekaný cesnak.', 'Pridajte paradajky, osoľte a varte 10–15 minút.', 'Omáčku premiešajte so špagetami a podávajte s bazalkou.'],
    duration: 25, affordability: Affordability.affordable, complexity: Complexity.simple,
    isGlutenFree: false, isLactoseFree: true, isVegan: true, isVegetarian: true,
  ),
  Meal(
    id: 'm2', categories: ['c1'], title: 'Krémové rizoto s hubami',
    imageUrl: 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=1000',
    ingredients: ['250 g ryže arborio', '200 g šampiňónov', '1 cibuľa', '700 ml zeleninového vývaru', '30 g parmezánu', 'Olivový olej'],
    steps: ['Nakrájajte cibuľu a huby.', 'Na oleji zmäknite cibuľu, pridajte huby a ryžu.', 'Postupne prilievajte teplý vývar a miešajte, kým ryža nezmäkne.', 'Vmiešajte parmezán a podávajte.'],
    duration: 35, affordability: Affordability.affordable, complexity: Complexity.challenging,
    isGlutenFree: true, isLactoseFree: false, isVegan: false, isVegetarian: true,
  ),
  Meal(
    id: 'm3', categories: ['c3', 'c2'], title: 'Domáci cheeseburger',
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=1000',
    ingredients: ['2 žemle na burger', '300 g hovädzieho mäsa', '2 plátky syra', 'Šalát', 'Paradajka', 'Soľ a korenie'],
    steps: ['Mäso osoľte, okoreňte a vytvarujte dve placky.', 'Placky opečte na rozpálenej panvici alebo grile.', 'Na mäso položte syr, aby sa roztopil.', 'Žemle naplňte šalátom, mäsom, paradajkou a obľúbenou omáčkou.'],
    duration: 30, affordability: Affordability.pricey, complexity: Complexity.simple,
    isGlutenFree: false, isLactoseFree: false, isVegan: false, isVegetarian: false,
  ),
  Meal(
    id: 'm4', categories: ['c5', 'c2'], title: 'Avokádový šalát',
    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=1000',
    ingredients: ['1 zrelé avokádo', '150 g cherry paradajok', '1 uhorka', 'Šťava z polovice citróna', 'Olivový olej', 'Čerstvá petržlenová vňať'],
    steps: ['Zeleninu umyte a nakrájajte.', 'Avokádo rozpoľte, odstráňte kôstku a nakrájajte na kúsky.', 'Všetko vložte do misy.', 'Pridajte citrónovú šťavu, olivový olej a bylinky, jemne premiešajte.'],
    duration: 15, affordability: Affordability.affordable, complexity: Complexity.simple,
    isGlutenFree: true, isLactoseFree: true, isVegan: true, isVegetarian: true,
  ),
  Meal(
    id: 'm5', categories: ['c4'], title: 'Tradičný nemecký rezeň',
    imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=1000',
    ingredients: ['2 bravčové alebo teľacie rezne', '1 vajce', 'Múka', 'Strúhanka', 'Olej na vyprážanie', 'Soľ a citrón'],
    steps: ['Mäso naklepte a osoľte.', 'Pripravte tri taniere: múka, rozšľahané vajce a strúhanka.', 'Mäso obaľte v tomto poradí.', 'Vyprážajte na stredne horúcom oleji dozlatista a podávajte s citrónom.'],
    duration: 40, affordability: Affordability.pricey, complexity: Complexity.challenging,
    isGlutenFree: false, isLactoseFree: true, isVegan: false, isVegetarian: false,
  ),
  Meal(
    id: 'm6', categories: ['c6', 'c8'], title: 'Kokosové zeleninové kari',
    imageUrl: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=1000',
    ingredients: ['1 plechovka kokosového mlieka', '1 paprika', '1 cuketa', '200 g cíceru', '2 ČL kari korenia', 'Ryža na podávanie'],
    steps: ['Nakrájajte zeleninu na kúsky.', 'V hrnci krátko opečte kari korenie.', 'Pridajte zeleninu, cícer a kokosové mlieko.', 'Duste 15–20 minút a podávajte s uvarenou ryžou.'],
    duration: 30, affordability: Affordability.affordable, complexity: Complexity.simple,
    isGlutenFree: true, isLactoseFree: true, isVegan: true, isVegetarian: true,
  ),
  Meal(
    id: 'm7', categories: ['c7', 'c2'], title: 'Banánové ovsené lievance',
    imageUrl: 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=1000',
    ingredients: ['1 zrelý banán', '100 g ovsených vločiek', '2 vajcia', '100 ml mlieka', 'Štipka škorice', 'Olej na panvicu'],
    steps: ['Banán roztlačte vidličkou.', 'Primiešajte vajcia, vločky, mlieko a škoricu.', 'Na mierne naolejovanej panvici vytvárajte malé lievance.', 'Opekajte z oboch strán a podávajte s ovocím.'],
    duration: 20, affordability: Affordability.affordable, complexity: Complexity.simple,
    isGlutenFree: false, isLactoseFree: false, isVegan: false, isVegetarian: true,
  ),
  Meal(
    id: 'm8', categories: ['c8', 'c5'], title: 'Ryžová miska s tofu',
    imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=1000',
    ingredients: ['200 g ryže', '200 g tofu', '1 mrkva', '1 uhorka', '2 PL sójovej omáčky', 'Sezam'],
    steps: ['Ryžu uvarte podľa návodu.', 'Tofu nakrájajte na kocky a opečte dozlatista.', 'Mrkvu a uhorku nakrájajte na tenké pásiky.', 'Do misky dajte ryžu, zeleninu a tofu. Pokvapkajte sójovou omáčkou a posypte sezamom.'],
    duration: 25, affordability: Affordability.affordable, complexity: Complexity.simple,
    isGlutenFree: false, isLactoseFree: true, isVegan: true, isVegetarian: true,
  ),
];
