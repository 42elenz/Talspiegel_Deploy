import 'models.dart';

enum MedicationType {
  Substanzklasse,
  Antidepressiva,
  Antikonvulsiva,
  Antipsychotika,
  Anxiolytika,
  Sucht,
  Sonstige
}

List<String> medications = [
  'Filtern nach Substanzklasse',
  'Antidepressiva',
  'Antikonvulsiva',
  'Antipsychotika',
  'Anxiolytika',
  'Sucht-Med.',
  'Sonstige'
];

List<Medication?> dropdownItems = [
  null,
];

List<Medication?> SuchtItems = [
  null,
  Medication(name: 'Acamprosat', mintal: 24, hlf: 13),
  Medication(name: 'Buprenorphin', mintal: 24, hlf: 28),
  Medication(name: 'NDesmethylbuprenorphin', mintal: 24, hlf: 69),
  Medication(name: 'Bupropion', mintal: 24, hlf: 20),
  Medication(name: 'Hydroxybupropion', mintal: 24, hlf: 28),
  Medication(name: 'Clomethiazol', mintal: 24, hlf: 4),
  Medication(name: 'Morphin', mintal: 24, hlf: 2),
  Medication(name: 'Disulfiram', mintal: 24, hlf: 7),
  Medication(name: 'Diethyldithiomethylcarbamat', mintal: 24, hlf: 22),
  Medication(name: 'Levomethadon', mintal: 24, hlf: 35),
  Medication(name: 'Methadon', mintal: 24, hlf: 34),
  Medication(name: 'Nalmefen', mintal: 24, hlf: 13),
  Medication(name: 'Naltrexon', mintal: 24, hlf: 4),
  Medication(name: '6βNaltrexol', mintal: 24, hlf: 11),
  Medication(name: 'Nikotin (Kaugummi)', mintal: 24, hlf: 2),
  Medication(name: 'Vareniclin', mintal: 24, hlf: 24),
];

List<Medication?> SonstigeItems = [
  null,
  Medication(name: 'Atomoxetin', mintal: 24, hlf: 4),
  Medication(name: 'Dextroamphetamin', mintal: 24, hlf: 9),
  Medication(name: 'Dexmethylphenidat', mintal: 24, hlf: 3),
  Medication(name: 'Donepezil', mintal: 24, hlf: 70),
  Medication(name: 'Galantamin', mintal: 24, hlf: 9),
  Medication(name: 'Guanfacin', mintal: 24, hlf: 18),
  Medication(name: 'Lisdexamfetamin', mintal: 24, hlf: 1),
  Medication(name: 'dAmphetamin', mintal: 24, hlf: 11),
  Medication(name: 'Memantin', mintal: 24, hlf: 64),
  Medication(name: 'd,lMethylphenidat unret.', mintal: 24, hlf: 2),
  Medication(name: 'Methylphenidat ret.', mintal: 24, hlf: 4),
  Medication(name: 'Modafinil', mintal: 24, hlf: 14),
  Medication(name: 'Pramipexol', mintal: 24, hlf: 8),
  Medication(name: 'Rivastigmin', mintal: 24, hlf: 2),
  Medication(name: 'Ropinirol', mintal: 24, hlf: 6),
];

List<Medication?> AnxiolytikaItems = [
  null,
  Medication(name: 'Alprazolam', mintal: 24, hlf: 13),
  Medication(name: 'Bromazepam', mintal: 24, hlf: 23),
  Medication(name: 'Brotizolam', mintal: 24, hlf: 5),
  Medication(name: 'Buspiron', mintal: 24, hlf: 3),
  Medication(name: '1Pyrimidinylpiperazin', mintal: 24, hlf: 5),
  Medication(name: '6Hydroxybuspiron', mintal: 24, hlf: 6),
  Medication(name: 'Chlordiazepoxid', mintal: 24, hlf: 22),
  Medication(name: 'Clonazepam', mintal: 24, hlf: 25),
  Medication(name: 'Clorazepat', mintal: 24, hlf: 2),
  Medication(name: 'NDesmethyldiazepam', mintal: 24, hlf: 53),
  Medication(name: 'Diazepam', mintal: 24, hlf: 43),
  Medication(name: 'NDesmethyldiazepam', mintal: 24, hlf: 65),
  Medication(name: 'Diphenhydramin', mintal: 24, hlf: 10),
  Medication(name: 'Doxylamin', mintal: 24, hlf: 10),
  Medication(name: 'Flunitrazepam', mintal: 24, hlf: 26),
  Medication(name: 'Flurazepam', mintal: 24, hlf: 3),
  Medication(name: 'NDesalkylflurazepam', mintal: 24, hlf: 75),
  Medication(name: 'Hydroxyethylflurazepam', mintal: 24, hlf: 3),
  Medication(name: 'Hydroxyzin', mintal: 24, hlf: 14),
  Medication(name: 'Lorazepam', mintal: 24, hlf: 14),
  Medication(name: 'Lormetazepam', mintal: 24, hlf: 12),
  Medication(name: 'Midazolam', mintal: 24, hlf: 2),
  Medication(name: 'Nitrazepam', mintal: 24, hlf: 28),
  Medication(name: 'Opipramol', mintal: 24, hlf: 11),
  Medication(name: 'Oxazepam', mintal: 24, hlf: 20),
  Medication(name: 'Pregabalin', mintal: 24, hlf: 6),
  Medication(name: 'Prazepam', mintal: 24, hlf: 1),
  Medication(name: 'NDesmethyldiazepam', mintal: 24, hlf: 65),
  Medication(name: 'Promethazin', mintal: 24, hlf: 12),
  Medication(name: 'Temazepam', mintal: 24, hlf: 8),
  Medication(name: 'Triazolam', mintal: 24, hlf: 3),
  Medication(name: 'Zaleplon', mintal: 24, hlf: 1),
  Medication(name: 'Zolpidem', mintal: 24, hlf: 2),
  Medication(name: 'Zopiclon', mintal: 24, hlf: 4),
];

List<Medication?> AntikonvulsivaItems = [
  null,
  Medication(name: 'Brivaracetam', mintal: 24, hlf: 9),
  Medication(name: 'Carbamazepin', mintal: 24, hlf: 15),
  Medication(name: 'Clobazam', mintal: 24, hlf: 32),
  Medication(name: 'NDesmethylclobazam', mintal: 24, hlf: 57),
  Medication(name: 'Felbamat', mintal: 24, hlf: 19),
  Medication(name: 'Lamotrigin', mintal: 24, hlf: 14),
  Medication(name: 'Levetiracetam', mintal: 24, hlf: 7),
  Medication(name: 'Lithium', mintal: 24, hlf: 24),
  Medication(name: 'Oxcarbazepin', mintal: 24, hlf: 2),
  Medication(name: '10Monohydroxycarbamazepin', mintal: 24, hlf: 9),
  Medication(name: 'Phenobarbital', mintal: 24, hlf: 20),
  Medication(name: 'Rufinamid', mintal: 24, hlf: 8),
  Medication(name: 'Topiramat', mintal: 24, hlf: 8),
  Medication(name: 'Valproat', mintal: 24, hlf: 14),
];

List<Medication?> AntpsychotikaItems = [
  null,
  Medication(name: 'Amisulprid', mintal: 24, hlf: 16),
  Medication(name: 'Aripiprazol', mintal: 24, hlf: 70),
  Medication(name: 'Asenapin', mintal: 24, hlf: 24),
  Medication(name: 'Benperidol', mintal: 24, hlf: 8),
  Medication(name: 'Brexpiprazol', mintal: 24, hlf: 91),
  Medication(name: 'Bromperidol', mintal: 24, hlf: 20),
  Medication(name: 'Cariprazin', mintal: 24, hlf: 44),
  Medication(name: 'NDesmethylcariprazin', mintal: 24, hlf: 37),
  Medication(name: 'Chlorpromazin', mintal: 24, hlf: 30),
  Medication(name: 'Chlorprothixen', mintal: 24, hlf: 10),
  Medication(name: 'Clozapin', mintal: 24, hlf: 12),
  Medication(name: 'NDesmethylclozapin', mintal: 24, hlf: 8),
  Medication(name: 'Flupentixol', mintal: 24, hlf: 35),
  Medication(name: 'Fluphenazin', mintal: 24, hlf: 16),
  Medication(name: 'Haloperidol', mintal: 24, hlf: 18),
  Medication(name: 'Iloperidon', mintal: 24, hlf: 18),
  Medication(name: 'Levomepromazin', mintal: 24, hlf: 28),
  Medication(name: 'Levosulpirid', mintal: 24, hlf: 8),
  Medication(name: 'Loxapin', mintal: 24, hlf: 7),
  Medication(name: 'Lurasidon', mintal: 24, hlf: 24),
  Medication(name: 'Melperon', mintal: 24, hlf: 5),
  Medication(name: 'Olanzapin', mintal: 24, hlf: 33),
  Medication(name: 'Paliperidon', mintal: 24, hlf: 20),
  Medication(name: 'Perazin', mintal: 24, hlf: 12),
  Medication(name: 'Perphenazin', mintal: 24, hlf: 10),
  Medication(name: 'Pimozid', mintal: 24, hlf: 33),
  Medication(name: 'Pipamperon', mintal: 24, hlf: 15),
  Medication(name: 'Prothipendyl', mintal: 24, hlf: 3),
  Medication(name: 'Quetiapin unret.', mintal: 24, hlf: 8),
  Medication(name: 'Desalkylquetiapin unret.', mintal: 24, hlf: 18),
  Medication(name: 'Quetiapin ret.', mintal: 24, hlf: 8),
  Medication(name: 'Desalkylquetiapin ret.', mintal: 24, hlf: 18),
  Medication(name: 'Risperidon', mintal: 24, hlf: 3),
  Medication(name: '9Hydroxyrisperidon', mintal: 24, hlf: 20),
  Medication(name: 'Sertindol', mintal: 24, hlf: 73),
  Medication(name: 'Sulpirid', mintal: 24, hlf: 8),
  Medication(name: 'Thioridazin', mintal: 24, hlf: 30),
  Medication(name: 'Ziprasidon', mintal: 24, hlf: 7),
  Medication(name: 'Zotepin', mintal: 24, hlf: 15),
  Medication(name: 'Zuclopenthixol', mintal: 24, hlf: 18),
];

List<Medication?> AntidepressivaItems = [
  null,
  Medication(name: 'Amitriptylin', mintal: 24, hlf: 19),
  Medication(name: 'Bupropion', mintal: 24, hlf: 19),
  Medication(name: 'Citalopram', mintal: 24, hlf: 36),
  Medication(name: 'NDesmethylcitalopram', mintal: 24, hlf: 50),
  Medication(name: 'Clomipramin', mintal: 24, hlf: 21),
  Medication(name: 'NDesmetylclomipramin', mintal: 24, hlf: 36),
  Medication(name: 'Desipramin', mintal: 24, hlf: 22),
  Medication(name: 'Desvenlafaxin', mintal: 24, hlf: 14),
  Medication(name: 'Doxepin', mintal: 24, hlf: 17),
  Medication(name: 'NDesmethyldoxepin', mintal: 24, hlf: 51),
  Medication(name: 'Duloxetin', mintal: 24, hlf: 12),
  Medication(name: 'Escitalopram', mintal: 24, hlf: 30),
  Medication(name: 'NDesmethylescitalopram', mintal: 24, hlf: 52),
  Medication(name: 'Fluoxetin', mintal: 24, hlf: 120),
  Medication(name: 'NDesmethylfluoxetin', mintal: 24, hlf: 240),
  Medication(name: 'Fluvoxamin', mintal: 24, hlf: 20),
  Medication(name: 'Imipramin', mintal: 24, hlf: 12),
  Medication(name: 'Desipramin', mintal: 24, hlf: 21),
  Medication(name: 'Levomilnacipran', mintal: 24, hlf: 21),
  Medication(name: 'Maprotilin', mintal: 24, hlf: 40),
  Medication(name: 'Mianserin', mintal: 24, hlf: 32),
  Medication(name: 'Milnacipran', mintal: 24, hlf: 8),
  Medication(name: 'Mirtazapin', mintal: 24, hlf: 30),
  Medication(name: 'Moclobemid', mintal: 24, hlf: 3),
  Medication(name: 'Nortriptylin', mintal: 24, hlf: 30),
  Medication(name: 'Paroxetin', mintal: 24, hlf: 19),
  Medication(name: 'Reboxetin', mintal: 24, hlf: 10),
  Medication(name: 'Sertralin', mintal: 24, hlf: 26),
  Medication(name: 'NDesmethylsertralin', mintal: 24, hlf: 70),
  Medication(name: 'Tianeptin', mintal: 24, hlf: 3),
  Medication(name: 'Tranylcypromin', mintal: 24, hlf: 3),
  Medication(name: 'Trazodon', mintal: 24, hlf: 7),
  Medication(name: 'Trimipramin', mintal: 24, hlf: 24),
  Medication(name: 'Venlafaxin non ret.', mintal: 24, hlf: 6),
  Medication(name: 'ODesmethylvenlafaxin non ret.', mintal: 24, hlf: 11),
  Medication(name: 'Venlafaxin retard', mintal: 24, hlf: 11),
  Medication(name: 'ODesmethylvenlafaxin ret.', mintal: 24, hlf: 20),
  Medication(name: 'NDesmethylvenlafaxin', mintal: 24, hlf: 7),
  Medication(name: 'Vilazodon', mintal: 24, hlf: 32),
  Medication(name: 'Vortioxetin', mintal: 24, hlf: 66)
];

List<Medication?> AllItems = [
  null,
  Medication(name: 'Acamprosat', mintal: 24, hlf: 13),
  Medication(name: 'Buprenorphin', mintal: 24, hlf: 28),
  Medication(name: 'NDesmethylbuprenorphin', mintal: 24, hlf: 69),
  Medication(name: 'Hydroxybupropion', mintal: 24, hlf: 28),
  Medication(name: 'Clomethiazol', mintal: 24, hlf: 4),
  Medication(name: 'Morphin', mintal: 24, hlf: 2),
  Medication(name: 'Disulfiram', mintal: 24, hlf: 7),
  Medication(name: 'Diethyldithiomethylcarbamat', mintal: 24, hlf: 22),
  Medication(name: 'Levomethadon', mintal: 24, hlf: 35),
  Medication(name: 'Methadon', mintal: 24, hlf: 34),
  Medication(name: 'Nalmefen', mintal: 24, hlf: 13),
  Medication(name: 'Naltrexon', mintal: 24, hlf: 4),
  Medication(name: '6βNaltrexol', mintal: 24, hlf: 11),
  Medication(name: 'Nikotin (Kaugummi)', mintal: 24, hlf: 2),
  Medication(name: 'Vareniclin', mintal: 24, hlf: 24),
  Medication(name: 'Atomoxetin', mintal: 24, hlf: 4),
  Medication(name: 'Dextroamphetamin', mintal: 24, hlf: 9),
  Medication(name: 'Dexmethylphenidat', mintal: 24, hlf: 3),
  Medication(name: 'Donepezil', mintal: 24, hlf: 70),
  Medication(name: 'Galantamin', mintal: 24, hlf: 9),
  Medication(name: 'Guanfacin', mintal: 24, hlf: 18),
  Medication(name: 'Lisdexamfetamin', mintal: 24, hlf: 1),
  Medication(name: 'dAmphetamin', mintal: 24, hlf: 11),
  Medication(name: 'Memantin', mintal: 24, hlf: 64),
  Medication(name: 'd,lMethylphenidat unret.', mintal: 24, hlf: 2),
  Medication(name: 'Methylphenidat ret.', mintal: 24, hlf: 4),
  Medication(name: 'Modafinil', mintal: 24, hlf: 14),
  Medication(name: 'Pramipexol', mintal: 24, hlf: 8),
  Medication(name: 'Rivastigmin', mintal: 24, hlf: 2),
  Medication(name: 'Ropinirol', mintal: 24, hlf: 6),
  Medication(name: 'Alprazolam', mintal: 24, hlf: 13),
  Medication(name: 'Bromazepam', mintal: 24, hlf: 23),
  Medication(name: 'Brotizolam', mintal: 24, hlf: 5),
  Medication(name: 'Buspiron', mintal: 24, hlf: 3),
  Medication(name: '1Pyrimidinylpiperazin', mintal: 24, hlf: 5),
  Medication(name: '6Hydroxybuspiron', mintal: 24, hlf: 6),
  Medication(name: 'Chlordiazepoxid', mintal: 24, hlf: 22),
  Medication(name: 'Clonazepam', mintal: 24, hlf: 25),
  Medication(name: 'Clorazepat', mintal: 24, hlf: 2),
  Medication(name: 'NDesmethyldiazepam', mintal: 24, hlf: 53),
  Medication(name: 'Diazepam', mintal: 24, hlf: 43),
  Medication(name: 'Diphenhydramin', mintal: 24, hlf: 10),
  Medication(name: 'Doxylamin', mintal: 24, hlf: 10),
  Medication(name: 'Flunitrazepam', mintal: 24, hlf: 26),
  Medication(name: 'Flurazepam', mintal: 24, hlf: 3),
  Medication(name: 'NDesalkylflurazepam', mintal: 24, hlf: 75),
  Medication(name: 'Hydroxyethylflurazepam', mintal: 24, hlf: 3),
  Medication(name: 'Hydroxyzin', mintal: 24, hlf: 14),
  Medication(name: 'Lorazepam', mintal: 24, hlf: 14),
  Medication(name: 'Lormetazepam', mintal: 24, hlf: 12),
  Medication(name: 'Midazolam', mintal: 24, hlf: 2),
  Medication(name: 'Nitrazepam', mintal: 24, hlf: 28),
  Medication(name: 'Opipramol', mintal: 24, hlf: 11),
  Medication(name: 'Oxazepam', mintal: 24, hlf: 20),
  Medication(name: 'Pregabalin', mintal: 24, hlf: 6),
  Medication(name: 'Prazepam', mintal: 24, hlf: 1),
  Medication(name: 'Promethazin', mintal: 24, hlf: 12),
  Medication(name: 'Temazepam', mintal: 24, hlf: 8),
  Medication(name: 'Triazolam', mintal: 24, hlf: 3),
  Medication(name: 'Zaleplon', mintal: 24, hlf: 1),
  Medication(name: 'Zolpidem', mintal: 24, hlf: 2),
  Medication(name: 'Zopiclon', mintal: 24, hlf: 4),
  Medication(name: 'Brivaracetam', mintal: 24, hlf: 9),
  Medication(name: 'Carbamazepin', mintal: 24, hlf: 15),
  Medication(name: 'Clobazam', mintal: 24, hlf: 32),
  Medication(name: 'NDesmethylclobazam', mintal: 24, hlf: 57),
  Medication(name: 'Felbamat', mintal: 24, hlf: 19),
  Medication(name: 'Lamotrigin', mintal: 24, hlf: 14),
  Medication(name: 'Levetiracetam', mintal: 24, hlf: 7),
  Medication(name: 'Lithium', mintal: 24, hlf: 24),
  Medication(name: 'Oxcarbazepin', mintal: 24, hlf: 2),
  Medication(name: '10Monohydroxycarbamazepin', mintal: 24, hlf: 9),
  Medication(name: 'Phenobarbital', mintal: 24, hlf: 20),
  Medication(name: 'Rufinamid', mintal: 24, hlf: 8),
  Medication(name: 'Topiramat', mintal: 24, hlf: 8),
  Medication(name: 'Valproat', mintal: 24, hlf: 14),
  Medication(name: 'Amisulprid', mintal: 24, hlf: 16),
  Medication(name: 'Aripiprazol', mintal: 24, hlf: 70),
  Medication(name: 'Asenapin', mintal: 24, hlf: 24),
  Medication(name: 'Benperidol', mintal: 24, hlf: 8),
  Medication(name: 'Brexpiprazol', mintal: 24, hlf: 91),
  Medication(name: 'Bromperidol', mintal: 24, hlf: 20),
  Medication(name: 'Cariprazin', mintal: 24, hlf: 44),
  Medication(name: 'NDesmethylcariprazin', mintal: 24, hlf: 37),
  Medication(name: 'NDidesmethylcariprazin', mintal: 24, hlf: 446),
  Medication(name: 'Chlorpromazin', mintal: 24, hlf: 30),
  Medication(name: 'Chlorprothixen', mintal: 24, hlf: 10),
  Medication(name: 'Clozapin', mintal: 24, hlf: 12),
  Medication(name: 'NDesmethylclozapin', mintal: 24, hlf: 8),
  Medication(name: 'Flupentixol', mintal: 24, hlf: 35),
  Medication(name: 'Fluphenazin', mintal: 24, hlf: 16),
  Medication(name: 'Haloperidol', mintal: 24, hlf: 18),
  Medication(name: 'Iloperidon', mintal: 24, hlf: 18),
  Medication(name: 'Levomepromazin', mintal: 24, hlf: 28),
  Medication(name: 'Levosulpirid', mintal: 24, hlf: 8),
  Medication(name: 'Loxapin', mintal: 24, hlf: 7),
  Medication(name: 'Lurasidon', mintal: 24, hlf: 24),
  Medication(name: 'Melperon', mintal: 24, hlf: 5),
  Medication(name: 'Olanzapin', mintal: 24, hlf: 33),
  Medication(name: 'Paliperidon', mintal: 24, hlf: 20),
  Medication(name: 'Perazin', mintal: 24, hlf: 12),
  Medication(name: 'Perphenazin', mintal: 24, hlf: 10),
  Medication(name: 'Pimozid', mintal: 24, hlf: 33),
  Medication(name: 'Pipamperon', mintal: 24, hlf: 15),
  Medication(name: 'Prothipendyl', mintal: 24, hlf: 3),
  Medication(name: 'Quetiapin unret.', mintal: 24, hlf: 8),
  Medication(name: 'Desalkylquetiapin unret.', mintal: 24, hlf: 18),
  Medication(name: 'Quetiapin ret.', mintal: 24, hlf: 8),
  Medication(name: 'Risperidon', mintal: 24, hlf: 3),
  Medication(name: '9Hydroxyrisperidon', mintal: 24, hlf: 20),
  Medication(name: 'Sertindol', mintal: 24, hlf: 73),
  Medication(name: 'Sulpirid', mintal: 24, hlf: 8),
  Medication(name: 'Thioridazin', mintal: 24, hlf: 30),
  Medication(name: 'Ziprasidon', mintal: 24, hlf: 7),
  Medication(name: 'Zotepin', mintal: 24, hlf: 15),
  Medication(name: 'Zuclopenthixol', mintal: 24, hlf: 18),
  Medication(name: 'Amitriptylin', mintal: 24, hlf: 19),
  Medication(name: 'Bupropion', mintal: 24, hlf: 19),
  Medication(name: 'Citalopram', mintal: 24, hlf: 36),
  Medication(name: 'NDesmethylcitalopram', mintal: 24, hlf: 50),
  Medication(name: 'Clomipramin', mintal: 24, hlf: 21),
  Medication(name: 'NDesmetylclomipramin', mintal: 24, hlf: 36),
  Medication(name: 'Desipramin', mintal: 24, hlf: 22),
  Medication(name: 'Desvenlafaxin', mintal: 24, hlf: 14),
  Medication(name: 'Doxepin', mintal: 24, hlf: 17),
  Medication(name: 'NDesmethyldoxepin', mintal: 24, hlf: 51),
  Medication(name: 'Duloxetin', mintal: 24, hlf: 12),
  Medication(name: 'Escitalopram', mintal: 24, hlf: 30),
  Medication(name: 'NDesmethylescitalopram', mintal: 24, hlf: 52),
  Medication(name: 'Fluoxetin', mintal: 24, hlf: 120),
  Medication(name: 'NDesmethylfluoxetin', mintal: 24, hlf: 240),
  Medication(name: 'Fluvoxamin', mintal: 24, hlf: 20),
  Medication(name: 'Imipramin', mintal: 24, hlf: 12),
  Medication(name: 'Levomilnacipran', mintal: 24, hlf: 21),
  Medication(name: 'Maprotilin', mintal: 24, hlf: 40),
  Medication(name: 'Mianserin', mintal: 24, hlf: 32),
  Medication(name: 'Milnacipran', mintal: 24, hlf: 8),
  Medication(name: 'Mirtazapin', mintal: 24, hlf: 30),
  Medication(name: 'Moclobemid', mintal: 24, hlf: 3),
  Medication(name: 'Nortriptylin', mintal: 24, hlf: 30),
  Medication(name: 'Paroxetin', mintal: 24, hlf: 19),
  Medication(name: 'Reboxetin', mintal: 24, hlf: 10),
  Medication(name: 'Sertralin', mintal: 24, hlf: 26),
  Medication(name: 'NDesmethylsertralin', mintal: 24, hlf: 70),
  Medication(name: 'Tianeptin', mintal: 24, hlf: 3),
  Medication(name: 'Tranylcypromin', mintal: 24, hlf: 3),
  Medication(name: 'Trazodon', mintal: 24, hlf: 7),
  Medication(name: 'Trimipramin', mintal: 24, hlf: 24),
  Medication(name: 'Venlafaxin non ret.', mintal: 24, hlf: 6),
  Medication(name: 'ODesmethylvenlafaxin non ret.', mintal: 24, hlf: 11),
  Medication(name: 'Venlafaxin retard', mintal: 24, hlf: 11),
  Medication(name: 'ODesmethylvenlafaxin ret.', mintal: 24, hlf: 20),
  Medication(name: 'NDesmethylvenlafaxin', mintal: 24, hlf: 7),
  Medication(name: 'Vilazodon', mintal: 24, hlf: 32),
  Medication(name: 'Vortioxetin', mintal: 24, hlf: 66)
];
