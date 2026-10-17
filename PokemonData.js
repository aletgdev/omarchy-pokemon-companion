.pragma library

var STRINGS = {
  es: {
    levelPrefix: "Nv. ",
    levelShort: "Nv.",
    friendshipTitle: "💖 Cariño / Amistad",
    expTitle: "⭐ Experiencia",
    berriesCount: "🍓 Bayas",
    berriesTooltip: "Recibes +1 baya cada 10 min de uso",
    feedBtn: "Baya",
    petBtn: "Acariciar",
    exploreBtn: "Explorar",
    chooseTitle: "Cambiar compañero:",
    langToggle: "🌐 Idioma: Español",
    noBerries: "¡No tienes más bayas! Espera un poco a que aparezcan más.",
    fedSuccess: "🍓 ¡{name} disfrutó de la deliciosa baya! (+12 Amistad, +25 EXP)",
    fedLevelUp: "🎉 ¡{name} subió al nivel {level}! ¡Le encantó la baya Aranja!",
    petLevelUp: "🎉 ¡{name} subió al nivel {level} gracias a tu cariño!",
    wildAppeared: "🌲 ¡Un {name} salvaje apareció curioseando cerca de tu terminal!",
    companionChosen: "¡Elegiste a {name}! {cry}",
    companionDefault: "{cry} ¡{name} te acompaña fielmente!",
    petReactions: [
      "✨ ¡{name} salta de felicidad y te mira con cariño!",
      "💖 ¡{name} ronronea suavemente y siente su vínculo contigo!",
      "⭐ ¡{name} sonríe radiantemente y hace {cry}!",
      "💫 ¡{name} parece muy contento de acompañarte en Omarchy!"
    ]
  },
  en: {
    levelPrefix: "Lv. ",
    levelShort: "Lv.",
    friendshipTitle: "💖 Friendship / Affection",
    expTitle: "⭐ Experience",
    berriesCount: "🍓 Berries",
    berriesTooltip: "You get +1 berry every 10 min of uptime",
    feedBtn: "Berry",
    petBtn: "Pet",
    exploreBtn: "Explore",
    chooseTitle: "Choose companion:",
    langToggle: "🌐 Language: English",
    noBerries: "Out of berries! Wait a little bit for more to grow.",
    fedSuccess: "🍓 {name} enjoyed the delicious berry! (+12 Friendship, +25 EXP)",
    fedLevelUp: "🎉 {name} reached level {level}! Loved the Oran berry!",
    petLevelUp: "🎉 {name} reached level {level} thanks to your affection!",
    wildAppeared: "🌲 A wild {name} appeared curiously near your terminal!",
    companionChosen: "You chose {name}! {cry}",
    companionDefault: "{cry} {name} is faithfully by your side!",
    petReactions: [
      "✨ {name} jumps with joy and looks at you fondly!",
      "💖 {name} purrs gently and feels a deep bond with you!",
      "⭐ {name} smiles radiantly and cries {cry}!",
      "💫 {name} seems very happy to accompany you on Omarchy!"
    ]
  }
};

var POKEMON_ROSTER = [
  {
    id: 25,
    name: "Pikachu",
    color: "#f5d038",
    genus: { es: "Pokémon Ratón", en: "Mouse Pokémon" },
    types: { es: ["Eléctrico"], en: ["Electric"] },
    description: {
      es: "Almacena electricidad en sus mejillas rojas. Cuando se alegra, libera chispas.",
      en: "Stores electricity in its red cheeks. When happy, it releases sparks."
    },
    cry: "Pika-pika!"
  },
  {
    id: 133,
    name: "Eevee",
    color: "#b98e5e",
    genus: { es: "Pokémon Evolución", en: "Evolution Pokémon" },
    types: { es: ["Normal"], en: ["Normal"] },
    description: {
      es: "Su ADN es inestable y puede evolucionar en múltiples formas según su entorno.",
      en: "Its genetic code is irregular and can evolve into diverse forms."
    },
    cry: "Eev-uii!"
  },
  {
    id: 1,
    name: "Bulbasaur",
    color: "#48a880",
    genus: { es: "Pokémon Semilla", en: "Seed Pokémon" },
    types: { es: ["Planta", "Veneno"], en: ["Grass", "Poison"] },
    description: {
      es: "Lleva una semilla en su lomo desde que nace, la cual va creciendo poco a poco.",
      en: "A strange seed was planted on its back at birth and grows with it."
    },
    cry: "Bulba-saur!"
  },
  {
    id: 4,
    name: "Charmander",
    color: "#e66030",
    genus: { es: "Pokémon Lagarto", en: "Lizard Pokémon" },
    types: { es: ["Fuego"], en: ["Fire"] },
    description: {
      es: "La llama en la punta de su cola arde con su fuerza vital y muestra su ánimo.",
      en: "The flame on its tail indicates its life force and mood."
    },
    cry: "Char-char!"
  },
  {
    id: 7,
    name: "Squirtle",
    color: "#549be6",
    genus: { es: "Pokémon Tortuguita", en: "Tiny Turtle Pokémon" },
    types: { es: ["Agua"], en: ["Water"] },
    description: {
      es: "Se resguarda dentro de su caparazón y dispara chorros de agua con gran precisión.",
      en: "Shelters in its shell, then strikes back with spouts of water at any chance."
    },
    cry: "Squir-tle!"
  },
  {
    id: 94,
    name: "Gengar",
    color: "#83599e",
    genus: { es: "Pokémon Sombra", en: "Shadow Pokémon" },
    types: { es: ["Fantasma", "Veneno"], en: ["Ghost", "Poison"] },
    description: {
      es: "Se oculta en las sombras al anochecer. Si sientes un frío repentino, está cerca.",
      en: "Hides in people's shadows at night. If you feel a sudden chill, Gengar is near."
    },
    cry: "Gaaan-gar!"
  },
  {
    id: 143,
    name: "Snorlax",
    color: "#3d7373",
    genus: { es: "Pokémon Dormilón", en: "Sleeping Pokémon" },
    types: { es: ["Normal"], en: ["Normal"] },
    description: {
      es: "Come hasta 400 kg de comida al día y después se queda profundamente dormido.",
      en: "Very lazy. Just eats and sleeps. As its round bulk builds, it becomes even more lethargic."
    },
    cry: "Snoooor-lax!"
  },
  {
    id: 448,
    name: "Lucario",
    color: "#4d80a8",
    genus: { es: "Pokémon Aura", en: "Aura Pokémon" },
    types: { es: ["Lucha", "Acero"], en: ["Fighting", "Steel"] },
    description: {
      es: "Puede leer las auras de seres vivos y objetos a más de un kilómetro de distancia.",
      en: "Can read the thoughts and movements of its opponents by sensing their aura."
    },
    cry: "Lu-ca-rio!"
  },
  {
    id: 151,
    name: "Mew",
    color: "#e88bb0",
    genus: { es: "Pokémon Nueva Especie", en: "New Species Pokémon" },
    types: { es: ["Psíquico"], en: ["Psychic"] },
    description: {
      es: "Posee la composición genética de todos los Pokémon. Es juguetón e inteligente.",
      en: "Its DNA contains the genetic codes of all Pokémon. It appears only to pure hearts."
    },
    cry: "Mew-mew!"
  },
  {
    id: 54,
    name: "Psyduck",
    color: "#dca73a",
    genus: { es: "Pokémon Pato", en: "Duck Pokémon" },
    types: { es: ["Agua"], en: ["Water"] },
    description: {
      es: "Sufre de constantes jaquecas. Cuando el dolor es máximo, desata poderes psíquicos.",
      en: "Overwhelmed by headaches. When the pain reaches a peak, it uses psychokinesis."
    },
    cry: "Psy... ayayay!"
  }
];

function getStrings(lang) {
  return STRINGS[lang] || STRINGS.es;
}

function getPokemonById(id) {
  for (var i = 0; i < POKEMON_ROSTER.length; i++) {
    if (POKEMON_ROSTER[i].id === id) return POKEMON_ROSTER[i];
  }
  return POKEMON_ROSTER[0];
}

function nextPokemon(currentId) {
  for (var i = 0; i < POKEMON_ROSTER.length; i++) {
    if (POKEMON_ROSTER[i].id === currentId) {
      var nextIdx = (i + 1) % POKEMON_ROSTER.length;
      return POKEMON_ROSTER[nextIdx];
    }
  }
  return POKEMON_ROSTER[0];
}

function defaultState() {
  return {
    language: "es",
    pokemonId: 25,
    nickname: "",
    level: 5,
    exp: 30,
    maxExp: 100,
    friendship: 70,
    berries: 5,
    totalPets: 0,
    lastInteraction: Date.now()
  };
}

function feedBerry(state) {
  var lang = state.language || "es";
  var s = getStrings(lang);
  if (state.berries <= 0) {
    return { success: false, message: s.noBerries };
  }
  state.berries -= 1;
  state.friendship = Math.min(100, state.friendship + 12);
  state.exp += 25;
  var leveledUp = false;
  if (state.exp >= state.maxExp) {
    state.level += 1;
    state.exp -= state.maxExp;
    state.maxExp = Math.floor(state.maxExp * 1.25);
    leveledUp = true;
  }
  var pk = getPokemonById(state.pokemonId);
  var name = state.nickname || pk.name;
  var msg = leveledUp
    ? s.fedLevelUp.replace("{name}", name).replace("{level}", state.level)
    : s.fedSuccess.replace("{name}", name);
  return { success: true, message: msg, leveledUp: leveledUp };
}

function pet(state) {
  var lang = state.language || "es";
  var s = getStrings(lang);
  state.totalPets = (state.totalPets || 0) + 1;
  state.friendship = Math.min(100, state.friendship + 4);
  state.exp += 8;
  var leveledUp = false;
  if (state.exp >= state.maxExp) {
    state.level += 1;
    state.exp -= state.maxExp;
    state.maxExp = Math.floor(state.maxExp * 1.25);
    leveledUp = true;
  }
  var pk = getPokemonById(state.pokemonId);
  var name = state.nickname || pk.name;
  var reaction = s.petReactions[Math.floor(Math.random() * s.petReactions.length)];
  reaction = reaction.replace(/\{name\}/g, name).replace(/\{cry\}/g, pk.cry);
  if (leveledUp) {
    reaction = s.petLevelUp.replace("{name}", name).replace("{level}", state.level);
  }
  return { success: true, message: reaction, leveledUp: leveledUp };
}
