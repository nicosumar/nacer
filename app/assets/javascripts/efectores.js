var Efector;

$(document).ready(function() {
  Efector = eval("[{\"id\":396,\"nombre\":\"Casa de la Mujer\"},{\"id\":326,\"nombre\":\"Centro de Diagnóstico Nº 366 «Domingo Furfuri»\"},{\"id\":234,\"nombre\":\"Centro de Salud Nº 100 «Cápiz»\"},{\"id\":65,\"nombre\":\"Centro de Salud Nº 101 «Dr. José María Méndez»\"},{\"id\":83,\"nombre\":\"Centro de Salud Nº 102 «Cochicó»\"},{\"id\":235,\"nombre\":\"Centro de Salud Nº 103 «Chilecito»\"},{\"id\":236,\"nombre\":\"Centro de Salud Nº 104 «Dr. Faustino Gil»\"},{\"id\":237,\"nombre\":\"Centro de Salud Nº 105 «Dr. Iván Cané»\"},{\"id\":238,\"nombre\":\"Centro de Salud Nº 106 «Paso de las Carretas»\"},{\"id\":198,\"nombre\":\"Centro de Salud Nº 107 «Villa 25 de Mayo»\"},{\"id\":199,\"nombre\":\"Centro de Salud Nº 108 «Goudge»\"},{\"id\":200,\"nombre\":\"Centro de Salud Nº 109 «Las Malvinas»\"},{\"id\":303,\"nombre\":\"Centro de Salud Nº 10 «Nueva Ciudad»\"},{\"id\":201,\"nombre\":\"Centro de Salud Nº 110 «Colonia Elena»\"},{\"id\":202,\"nombre\":\"Centro de Salud Nº 111 «Rodolfo Iselín»\"},{\"id\":203,\"nombre\":\"Centro de Salud Nº 112 «El Usillal»\"},{\"id\":75,\"nombre\":\"Centro de Salud Nº 113 «Monte Comán»\"},{\"id\":76,\"nombre\":\"Centro de Salud Nº 114 «Argentinos Uruguayos» (Villa Atuel)\"},{\"id\":204,\"nombre\":\"Centro de Salud Nº 115 «Real del Padre»\"},{\"id\":205,\"nombre\":\"Centro de Salud Nº 116 «Cuadro Benegas»\"},{\"id\":206,\"nombre\":\"Centro de Salud Nº 117 «El Nihuil»\"},{\"id\":207,\"nombre\":\"Centro de Salud Nº 118 «El Sosneado»\"},{\"id\":208,\"nombre\":\"Centro de Salud Nº 119 «Rama Caída»\"},{\"id\":8,\"nombre\":\"Centro de Salud Nº 11 «Santa Elvira»\"},{\"id\":55,\"nombre\":\"Centro de Salud Nº 120 «Alvear Oeste»\"},{\"id\":54,\"nombre\":\"Centro de Salud Nº 121  «Bowen»\"},{\"id\":84,\"nombre\":\"Centro de Salud Nº 122  «Carmensa»\"},{\"id\":209,\"nombre\":\"Centro de Salud Nº 123 «Punta del Agua»\"},{\"id\":187,\"nombre\":\"Centro de Salud Nº 124 «El alambrado»\"},{\"id\":188,\"nombre\":\"Centro de Salud Nº 125 «Ranquil Norte»\"},{\"id\":189,\"nombre\":\"Centro de Salud Nº 126 «Dr. Raúl Pedro Facundo \\\"tata\\\" Quiroga»\"},{\"id\":190,\"nombre\":\"Centro de Salud Nº 127 «El cortaderal»\"},{\"id\":85,\"nombre\":\"Centro de Salud Nº 128  «Isla Gorastiague»\"},{\"id\":62,\"nombre\":\"Centro de Salud Nº 129 «s/n»\"},{\"id\":9,\"nombre\":\"Centro de Salud Nº 12 «Bermejo»\"},{\"id\":210,\"nombre\":\"Centro de Salud Nº 130 «Salto de las Rosas»\"},{\"id\":132,\"nombre\":\"Centro de Salud Nº 131 «Lagunitas»\"},{\"id\":191,\"nombre\":\"Centro de Salud Nº 132 «Bardas blancas»\"},{\"id\":133,\"nombre\":\"Centro de Salud Nº 133 «La Asunción»\"},{\"id\":22,\"nombre\":\"Centro de Salud Nº 134 «SOEVA Norte»\"},{\"id\":192,\"nombre\":\"Centro de Salud Nº 135 «Pata Mora»\"},{\"id\":31,\"nombre\":\"Centro de Salud Nº 136 «Juan Minetti»\"},{\"id\":86,\"nombre\":\"Centro de Salud Nº 137 «San Pedro»\"},{\"id\":87,\"nombre\":\"Centro de Salud Nº 138 «El Ceibo»\"},{\"id\":118,\"nombre\":\"Centro de Salud Nº 139 «Barrio Municipal»\"},{\"id\":304,\"nombre\":\"Centro de Salud Nº 13 «Colonia Segovia»\"},{\"id\":88,\"nombre\":\"Centro de Salud Nº 140 «Canalejas»\"},{\"id\":89,\"nombre\":\"Centro de Salud Nº 141 «Corral de Lorca»\"},{\"id\":211,\"nombre\":\"Centro de Salud Nº 142 «Bombal y Tabanera»\"},{\"id\":193,\"nombre\":\"Centro de Salud Nº 143 «Las Loicas»\"},{\"id\":239,\"nombre\":\"Centro de Salud Nº 144 «Fernando Chacón»\"},{\"id\":134,\"nombre\":\"Centro de Salud Nº 145 «El Forzudo»\"},{\"id\":369,\"nombre\":\"Centro de Salud Nº 146 «Los Campamentos»\"},{\"id\":240,\"nombre\":\"Centro de Salud Nº 147 «El Cepillo»\"},{\"id\":23,\"nombre\":\"Centro de Salud Nº 149 «Dr. Ramón Carrillo»\"},{\"id\":28,\"nombre\":\"Centro de Salud Nº 14 «Pedro Molina»\"},{\"id\":24,\"nombre\":\"Centro de Salud Nº 150 «Dr. Daniel Rebollo»\"},{\"id\":39,\"nombre\":\"Centro de Salud Nº 151 «Tropero Sosa»\"},{\"id\":288,\"nombre\":\"Centro de Salud Nº 153 «Las Pintadas»\"},{\"id\":289,\"nombre\":\"Centro de Salud Nº 154 «Agua Amarga»\"},{\"id\":165,\"nombre\":\"Centro de Salud Nº 156 «Costa Anzorena»\"},{\"id\":20,\"nombre\":\"Centro de Salud Nº 158 «Cuadro Nacional»\"},{\"id\":19,\"nombre\":\"Centro de Salud Nº 159 «Humberto Taranto»\"},{\"id\":305,\"nombre\":\"Centro de Salud Nº 15 «Ejército de los Andes»\"},{\"id\":212,\"nombre\":\"Centro de Salud Nº 160 «Tres Vientos»\"},{\"id\":213,\"nombre\":\"Centro de Salud Nº 161 «Atuel Norte»\"},{\"id\":278,\"nombre\":\"Centro de Salud Nº 162 «Balde de Piedra»\"},{\"id\":214,\"nombre\":\"Centro de Salud Nº 163 «Dr. Julio Hannon»\"},{\"id\":46,\"nombre\":\"Centro de Salud Nº 164 «Capitán Montoya»\"},{\"id\":194,\"nombre\":\"Centro de Salud Nº 165 «El Manzano»\"},{\"id\":255,\"nombre\":\"Centro de Salud Nº 167 «El divisadero»\"},{\"id\":15,\"nombre\":\"Centro de Salud Nº 168 «Dr. Nestor Kirchner»\"},{\"id\":1,\"nombre\":\"Centro de Salud Nº 16 «Villa Nueva»\"},{\"id\":215,\"nombre\":\"Centro de Salud Nº 170 «La Llave Vieja»\"},{\"id\":290,\"nombre\":\"Centro de Salud Nº 171 «Barrio Urquiza»\"},{\"id\":25,\"nombre\":\"Centro de Salud Nº 172 «Alicia Moreau de Justo»\"},{\"id\":166,\"nombre\":\"Centro de Salud Nº 173 «La Libertad»\"},{\"id\":47,\"nombre\":\"Centro de Salud Nº 175 «El Cerrito»\"},{\"id\":395,\"nombre\":\"Centro de Salud Nº 176 «La Junta»\"},{\"id\":195,\"nombre\":\"Centro de Salud Nº 177 «Dr. Francisco Luskar»\"},{\"id\":13,\"nombre\":\"Centro de Salud Nº 179 «Prof. E. Carbonari»\"},{\"id\":32,\"nombre\":\"Centro de Salud Nº 17 «Carlos Evans»\"},{\"id\":135,\"nombre\":\"Centro de Salud Nº 180 «Lotes Cavero»\"},{\"id\":291,\"nombre\":\"Centro de Salud Nº 181 «Villa Seca»\"},{\"id\":196,\"nombre\":\"Centro de Salud Nº 182 «Dr. Diógenes Quiroga»\"},{\"id\":21,\"nombre\":\"Centro de Salud Nº 183 «Barrio Valle Grande»\"},{\"id\":299,\"nombre\":\"Centro de Salud Nº 184 «Ítalo Palumbo»\"},{\"id\":306,\"nombre\":\"Centro de Salud Nº 185 «Juan Foucault»\"},{\"id\":272,\"nombre\":\"Centro de Salud Nº 186 «Villa Hortensia»\"},{\"id\":91,\"nombre\":\"Centro de Salud Nº 188 «La Escandinava»\"},{\"id\":256,\"nombre\":\"Centro de Salud Nº 189 «Colonia Lambaré»\"},{\"id\":33,\"nombre\":\"Centro de Salud Nº 18 «General Espejo»\"},{\"id\":257,\"nombre\":\"Centro de Salud Nº 190 «Río Mendoza»\"},{\"id\":292,\"nombre\":\"Centro de Salud Nº 191 «Puente del Río»\"},{\"id\":258,\"nombre\":\"Centro de Salud Nº 194 «Barrio López»\"},{\"id\":259,\"nombre\":\"Centro de Salud Nº 195 «Dr. Enrique Álvarez»\"},{\"id\":307,\"nombre\":\"Centro de Salud Nº 196 «Josefina Oro»\"},{\"id\":293,\"nombre\":\"Centro de Salud Nº 197 «El Algarrobo»\"},{\"id\":300,\"nombre\":\"Centro de Salud Nº 198 «Fermín Carrizo»\"},{\"id\":273,\"nombre\":\"Centro de Salud Nº 199 «Barrio Antártida Argentina»\"},{\"id\":43,\"nombre\":\"Centro de Salud Nº 1 «Bº San Martín»\"},{\"id\":156,\"nombre\":\"Centro de Salud Nº 202 «Perdriel»\"},{\"id\":274,\"nombre\":\"Centro de Salud Nº 203 «Chachingo»\"},{\"id\":98,\"nombre\":\"Centro de Salud Nº 204 «Barrio Sarmiento»\"},{\"id\":260,\"nombre\":\"Centro de Salud Nº 207 «Villa Adela»\"},{\"id\":261,\"nombre\":\"Centro de Salud Nº 208 «El Central»\"},{\"id\":384,\"nombre\":\"Centro de Salud Nº 209 «Elías Yamín»\"},{\"id\":34,\"nombre\":\"Centro de Salud Nº 20 «Barrio 26 de Enero»\"},{\"id\":308,\"nombre\":\"Centro de Salud Nº 210 «Bº Escorihuela»\"},{\"id\":82,\"nombre\":\"Centro de Salud Nº 211 «Jesús Nazareno»\"},{\"id\":101,\"nombre\":\"Centro de Salud Nº 212 «Nuestra Señora de los Milagros»\"},{\"id\":92,\"nombre\":\"Centro de Salud Nº 213 «Los Compartos»\"},{\"id\":102,\"nombre\":\"Centro de Salud Nº 214 «Barrio Lihué»\"},{\"id\":356,\"nombre\":\"Centro de Salud Nº 215 Equipo Sanitario  Itinerante (ESI)\"},{\"id\":157,\"nombre\":\"Centro de Salud Nº 217 «Los Olivos»\"},{\"id\":158,\"nombre\":\"Centro de Salud Nº 218 «Los Alerces»\"},{\"id\":104,\"nombre\":\"Centro de Salud Nº 219 «San Cayetano»\"},{\"id\":115,\"nombre\":\"Centro de Salud Nº 21 «El Borbollón»\"},{\"id\":93,\"nombre\":\"Centro de Salud Nº 220 «El Caldén»\"},{\"id\":119,\"nombre\":\"Centro de Salud Nº 221 «San Francisco de Asís»\"},{\"id\":105,\"nombre\":\"Centro de Salud Nº 222 «René Favaloro»\"},{\"id\":317,\"nombre\":\"Centro de Salud Nº 224 «Costa Flores»\"},{\"id\":79,\"nombre\":\"Centro de Salud Nº 225  «s/n»\"},{\"id\":81,\"nombre\":\"Centro de Salud Nº 226 «San Miguel»\"},{\"id\":309,\"nombre\":\"Centro de Salud Nº 228 «El Topón»\"},{\"id\":310,\"nombre\":\"Centro de Salud Nº 229 «El Martillo»\"},{\"id\":116,\"nombre\":\"Centro de Salud Nº 22 «Nazareno Domizzi»\"},{\"id\":311,\"nombre\":\"Centro de Salud Nº 230 «Otoyanes»\"},{\"id\":312,\"nombre\":\"Centro de Salud Nº 231 «Alto Verde»\"},{\"id\":313,\"nombre\":\"Centro de Salud Nº 232 «Barrio Ferroviario»\"},{\"id\":392,\"nombre\":\"Centro de Salud Nº 233 «Servicio Itinerante de General Alvear»\"},{\"id\":72,\"nombre\":\"Centro de Salud Nº 234 «Barrio Dorrego»\"},{\"id\":295,\"nombre\":\"Centro de Salud Nº 236 «El Manzano Histórico»\"},{\"id\":322,\"nombre\":\"Centro de Salud Nº 237 «José Pilo Repetto»\"},{\"id\":139,\"nombre\":\"Centro de Salud Nº 239 «Carlos Alberto Masoero» (antes C.S. Nº 501 La Pega)\"},{\"id\":138,\"nombre\":\"Centro de Salud Nº 240 «Dr. Lorenzo Di Marco»\"},{\"id\":335,\"nombre\":\"Centro de Salud Nº 241 «Andacollo»\"},{\"id\":262,\"nombre\":\"Centro de Salud Nº 242 «Ismael Yurie»\"},{\"id\":415,\"nombre\":\"Centro de Salud Nº 244 «La bajada»\"},{\"id\":117,\"nombre\":\"Centro de Salud Nº 24 «Polvaredas»\"},{\"id\":315,\"nombre\":\"Centro de Salud Nº 25 «Monteavaro»\"},{\"id\":97,\"nombre\":\"Centro de Salud Nº 27 «San Francisco del Monte»\"},{\"id\":26,\"nombre\":\"Centro de Salud Nº 28 «Dr. Juan Maurín Navarro»\"},{\"id\":12,\"nombre\":\"Centro de Salud Nº 29 «Villa Jovita»\"},{\"id\":18,\"nombre\":\"Centro de Salud Nº 2 «San Antonio»\"},{\"id\":44,\"nombre\":\"Centro de Salud Nº 300 «Dr. Arturo Oñativia»\"},{\"id\":11,\"nombre\":\"Centro de Salud Nº 302 «Padre Llorens»\"},{\"id\":100,\"nombre\":\"Centro de Salud Nº 304 «Barrio Fusch»\"},{\"id\":10,\"nombre\":\"Centro de Salud Nº 305 «Barrio F.O.E.C.Y.T»\"},{\"id\":27,\"nombre\":\"Centro de Salud Nº 30 «Dr. Aldo Dapas»\"},{\"id\":176,\"nombre\":\"Centro de Salud Nº 310 «Los Álamos»\"},{\"id\":177,\"nombre\":\"Centro de Salud Nº 311 «Isla Chica»\"},{\"id\":167,\"nombre\":\"Centro de Salud Nº 315 «Andrade»\"},{\"id\":168,\"nombre\":\"Centro de Salud Nº 316 «Dr. Arnaldo Victorio Felici»\"},{\"id\":169,\"nombre\":\"Centro de Salud Nº 317 «La Verde»\"},{\"id\":170,\"nombre\":\"Centro de Salud Nº 318 «Barrio Rivadavia»\"},{\"id\":178,\"nombre\":\"Centro de Salud Nº 319 «Jume»\"},{\"id\":36,\"nombre\":\"Centro de Salud Nº 31 «David Busana»\"},{\"id\":48,\"nombre\":\"Centro de Salud Nº 320 «El molino»\"},{\"id\":41,\"nombre\":\"Centro de Salud Nº 321 «Barrio Maugeri»\"},{\"id\":179,\"nombre\":\"Centro de Salud Nº 322 «Recoaro»\"},{\"id\":180,\"nombre\":\"Centro de Salud Nº 323 «Villa Seca» (Municipal Nº 7)\"},{\"id\":218,\"nombre\":\"Centro de Salud Nº 324 «Los Claveles»\"},{\"id\":73,\"nombre\":\"Centro de Salud Nº 325 «Pueblo Diamante»\"},{\"id\":181,\"nombre\":\"Centro de Salud Nº 326 «Russell» (Barrio La Superiora)\"},{\"id\":74,\"nombre\":\"Centro de Salud Nº 327 «Constitución»\"},{\"id\":171,\"nombre\":\"Centro de Salud Nº 328 «Albarracín Godoy»\"},{\"id\":49,\"nombre\":\"Centro de Salud Nº 329 «Teresa Scagliotti»\"},{\"id\":150,\"nombre\":\"Centro de Salud Nº 32 «Las Compuertas»\"},{\"id\":280,\"nombre\":\"Centro de Salud Nº 330 «12 de Octubre»\"},{\"id\":279,\"nombre\":\"Centro de Salud Nº 331 «El Marcado»\"},{\"id\":182,\"nombre\":\"Centro de Salud Nº 332 «Malcayaes»\"},{\"id\":17,\"nombre\":\"Centro de Salud Nº 333 «René Favaloro»\"},{\"id\":219,\"nombre\":\"Centro de Salud Nº 334 «Las Margaritas»\"},{\"id\":183,\"nombre\":\"Centro de Salud Nº 335 «Ruta 20»\"},{\"id\":172,\"nombre\":\"Centro de Salud Nº 336 «Titarelli»\"},{\"id\":63,\"nombre\":\"Centro de Salud Nº 337 «Titarelli II»\"},{\"id\":50,\"nombre\":\"Centro de Salud Nº 339 «Francisca Strólogo»\"},{\"id\":151,\"nombre\":\"Centro de Salud Nº 33 «La Colonia»\"},{\"id\":220,\"nombre\":\"Centro de Salud Nº 340 «Manos Unidas La Pichana»\"},{\"id\":60,\"nombre\":\"Centro de Salud Nº 342 «Colonia Bombal» (Municipal Nº 12)\"},{\"id\":221,\"nombre\":\"Centro de Salud Nº 344 «Juan Manuel García»\"},{\"id\":222,\"nombre\":\"Centro de Salud Nº 345 «Colonia Gelman»\"},{\"id\":223,\"nombre\":\"Centro de Salud Nº 346 «Los Coroneles»\"},{\"id\":51,\"nombre\":\"Centro de Salud Nº 347 Santa Teresa\"},{\"id\":224,\"nombre\":\"Centro de Salud Nº 348 «Colonia Española»\"},{\"id\":52,\"nombre\":\"Centro de Salud Nº 349 «Villa Laredo»\"},{\"id\":152,\"nombre\":\"Centro de Salud Nº 34 «Potrerillos»\"},{\"id\":323,\"nombre\":\"Centro de Salud Nº 350 «La Guevarina»\"},{\"id\":225,\"nombre\":\"Centro de Salud Nº 351 «El Tropezón»\"},{\"id\":184,\"nombre\":\"Centro de Salud Nº 352 «Cóndor y Andes»\"},{\"id\":57,\"nombre\":\"Centro de Salud Nº 353 «César Ortiz Guevara»\"},{\"id\":226,\"nombre\":\"Centro de Salud Nº 354 «La Llave Sur»\"},{\"id\":366,\"nombre\":\"Centro de Salud Nº 355 «La Riojita»\"},{\"id\":185,\"nombre\":\"Centro de Salud Nº 356 «Piccione»\"},{\"id\":186,\"nombre\":\"Centro de Salud Nº 357 «Titarelli»\"},{\"id\":227,\"nombre\":\"Centro de Salud Nº 359 «Las Malvinas Sur»\"},{\"id\":153,\"nombre\":\"Centro de Salud Nº 35 «Agrelo»\"},{\"id\":228,\"nombre\":\"Centro de Salud Nº 360 «Jesús Nazareno Riera»\"},{\"id\":229,\"nombre\":\"Centro de Salud Nº 361 «El Escorial»\"},{\"id\":120,\"nombre\":\"Centro de Salud Nº 362 «Antonio Huespe»\"},{\"id\":387,\"nombre\":\"Centro de Salud Nº 364 «Las Margaritas»\"},{\"id\":378,\"nombre\":\"Centro de Salud Nº 365 «Plazoleta Rutini» (Municipal Nº 16)\"},{\"id\":325,\"nombre\":\"Centro de Salud Nº 367 «Barrio Andino»\"},{\"id\":154,\"nombre\":\"Centro de Salud Nº 36 «Carrizal Arriba»\"},{\"id\":155,\"nombre\":\"Centro de Salud Nº 37 «Carrizal Abajo»\"},{\"id\":37,\"nombre\":\"Centro de Salud Nº 38 «Chacras de Coria»\"},{\"id\":59,\"nombre\":\"Centro de Salud Nº 39 «Ugarteche»\"},{\"id\":149,\"nombre\":\"Centro de Salud Nº 3 «Pablo Casale»\"},{\"id\":122,\"nombre\":\"Centro de Salud Nº 40 «El Vergel»\"},{\"id\":123,\"nombre\":\"Centro de Salud Nº 41 «Tres de Mayo»\"},{\"id\":124,\"nombre\":\"Centro de Salud Nº 42 «San Francisco»\"},{\"id\":58,\"nombre\":\"Centro de Salud Nº 43 «Costa de Araujo»\"},{\"id\":125,\"nombre\":\"Centro de Salud Nº 44 «Gustavo André»\"},{\"id\":126,\"nombre\":\"Centro de Salud Nº 45 «Jocolí»\"},{\"id\":127,\"nombre\":\"Centro de Salud Nº 46 «Lagunas del Rosario»\"},{\"id\":128,\"nombre\":\"Centro de Salud Nº 47 «San José»\"},{\"id\":129,\"nombre\":\"Centro de Salud Nº 48 «San Miguel»\"},{\"id\":130,\"nombre\":\"Centro de Salud Nº 49 «El Retamo»\"},{\"id\":6,\"nombre\":\"Centro de Salud Nº 4 «Los Glaciares»\"},{\"id\":245,\"nombre\":\"Centro de Salud Nº 50 «Hilda Tonini»\"},{\"id\":231,\"nombre\":\"Centro de Salud Nº 513 «San Francisco»\"},{\"id\":232,\"nombre\":\"Centro de Salud Nº 514 «El Toledano»\"},{\"id\":271,\"nombre\":\"Centro de Salud Nº 51 «Barrio Castañeda»\"},{\"id\":264,\"nombre\":\"Centro de Salud Nº 52 «General Ortega»\"},{\"id\":368,\"nombre\":\"Centro de Salud Nº 538 «La Izuelina»\"},{\"id\":265,\"nombre\":\"Centro de Salud Nº 53 «Cruz de Piedra»\"},{\"id\":230,\"nombre\":\"Centro de Salud Nº 541 «Madre Teresa de Calcuta – Oratorio Don Bosco»\"},{\"id\":372,\"nombre\":\"Centro de Salud Nº 542 «Barrio Municipal»\"},{\"id\":266,\"nombre\":\"Centro de Salud Nº 54 «Lunlunta»\"},{\"id\":370,\"nombre\":\"Centro de Salud Nº 558 «Dr. Marrelli»\"},{\"id\":267,\"nombre\":\"Centro de Salud Nº 55 «Barrancas»\"},{\"id\":61,\"nombre\":\"Centro de Salud Nº 56 «Rodeo del Medio»\"},{\"id\":268,\"nombre\":\"Centro de Salud Nº 57 «San Roque»\"},{\"id\":269,\"nombre\":\"Centro de Salud Nº 58 «Santa Blanca»\"},{\"id\":270,\"nombre\":\"Centro de Salud Nº 59 «Isla Grande»\"},{\"id\":29,\"nombre\":\"Centro de Salud Nº 5 «Pascual Lauriente»\"},{\"id\":38,\"nombre\":\"Centro de Salud Nº 60 «General Gutiérrez»\"},{\"id\":284,\"nombre\":\"Centro de Salud Nº 61 «La Primavera»\"},{\"id\":56,\"nombre\":\"Centro de Salud Nº 62 «Oscar A. Delellis»\"},{\"id\":106,\"nombre\":\"Centro de Salud Nº 63 «Barriales»\"},{\"id\":107,\"nombre\":\"Centro de Salud Nº 64 «Algarrobo Grande»\"},{\"id\":108,\"nombre\":\"Centro de Salud Nº 65 «Rodriguez Peña»\"},{\"id\":159,\"nombre\":\"Centro de Salud Nº 66 «El Mirador»\"},{\"id\":64,\"nombre\":\"Centro de Salud Nº 67 «Medrano»\"},{\"id\":160,\"nombre\":\"Centro de Salud Nº 68 «Los Árboles»\"},{\"id\":161,\"nombre\":\"Centro de Salud Nº 69 «La Central»\"},{\"id\":14,\"nombre\":\"Centro de Salud Nº 6 «Patrón Santiago»\"},{\"id\":162,\"nombre\":\"Centro de Salud Nº 70 «Reducción»\"},{\"id\":109,\"nombre\":\"Centro de Salud Nº 71 «Phillips»\"},{\"id\":77,\"nombre\":\"Centro de Salud Nº 73 «Dr. Orlando Vicente García Alonso»\"},{\"id\":276,\"nombre\":\"Centro de Salud Nº 74 «Dantis Abdón»\"},{\"id\":277,\"nombre\":\"Centro de Salud Nº 75 «Ñancuñán»\"},{\"id\":67,\"nombre\":\"Centro de Salud Nº 76 «Dr. Pérsico»\"},{\"id\":389,\"nombre\":\"Centro de Salud nº 77 \\\"Alto Montecaseros\\\"\"},{\"id\":110,\"nombre\":\"Centro de Salud Nº 78 «Ingeniero Giagnoni»\"},{\"id\":247,\"nombre\":\"Centro de Salud Nº 79 «Alto Verde»\"},{\"id\":3,\"nombre\":\"Centro de Salud Nº 7 «Andrés Bacigalupo»\"},{\"id\":248,\"nombre\":\"Centro de Salud Nº 80 «Ramblón»\"},{\"id\":249,\"nombre\":\"Centro de Salud Nº 81 «Chivilcoy»\"},{\"id\":250,\"nombre\":\"Centro de Salud Nº 82 «Buen orden»\"},{\"id\":66,\"nombre\":\"Centro de Salud Nº 83 «Chapanay»\"},{\"id\":251,\"nombre\":\"Centro de Salud Nº 84 «Simón Barbero»\"},{\"id\":252,\"nombre\":\"Centro de Salud Nº 85 «María Escudero»\"},{\"id\":253,\"nombre\":\"Centro de Salud Nº 86 «Tres Porteñas»\"},{\"id\":254,\"nombre\":\"Centro de Salud Nº 87 «Félix Fernández»\"},{\"id\":112,\"nombre\":\"Centro de Salud Nº 88 «Enfermero Eloy Giménez»\"},{\"id\":131,\"nombre\":\"Centro de Salud Nº 89 «Arroyito»\"},{\"id\":7,\"nombre\":\"Centro de Salud Nº 8 «Huarpes»\"},{\"id\":113,\"nombre\":\"Centro de Salud Nº 90 «Herminia Nielssen»\"},{\"id\":285,\"nombre\":\"Centro de Salud Nº 91 «Colonia Las Rosas»\"},{\"id\":68,\"nombre\":\"Centro de Salud Nº 92 «San José»\"},{\"id\":296,\"nombre\":\"Centro de Salud Nº 93 «La Carrera»\"},{\"id\":297,\"nombre\":\"Centro de Salud Nº 94 «El Algarrobo»\"},{\"id\":298,\"nombre\":\"Centro de Salud Nº 95 «El Zampal»\"},{\"id\":286,\"nombre\":\"Centro de Salud Nº 96 «Los Árboles»\"},{\"id\":287,\"nombre\":\"Centro de Salud Nº 97 «Los Sauces»\"},{\"id\":78,\"nombre\":\"Centro de Salud Nº 98 «José Delgado»\"},{\"id\":233,\"nombre\":\"Centro de Salud Nº 99 «San Carlos»\"},{\"id\":302,\"nombre\":\"Centro de Salud Nº 9 «Los Corralitos»\"},{\"id\":439,\"nombre\":\"Centro infanto juvenil Nº 1 «Godoy Cruz»\"},{\"id\":440,\"nombre\":\"Centro infanto juvenil Nº 3 «Maipú»\"},{\"id\":441,\"nombre\":\"Centro infanto juvenil Nº 4 «Tunuyán»\"},{\"id\":442,\"nombre\":\"Centro infanto juvenil Nº 5 «San Martín»\"},{\"id\":451,\"nombre\":\"Centro infanto juvenil Nº 6 «Lavalle»\"},{\"id\":443,\"nombre\":\"Centro infanto juvenil Nº 7 «San Rafael»\"},{\"id\":444,\"nombre\":\"Centro infanto juvenil Nº 8 «Guaymallén»\"},{\"id\":452,\"nombre\":\"Centro infanto juvenil Nº 9 «Tupungato»\"},{\"id\":449,\"nombre\":\"CENTRO PROVINCIAL ADICCIONES «General ALvear»\"},{\"id\":453,\"nombre\":\"CENTRO PROVINCIAL ADICCIONES «GODOY CRUZ»\"},{\"id\":445,\"nombre\":\"CENTRO PROVINCIAL ADICCIONES «Las Heras»\"},{\"id\":450,\"nombre\":\"CENTRO PROVINCIAL ADICCIONES «Lujan»\"},{\"id\":446,\"nombre\":\"CENTRO PROVINCIAL ADICCIONES «Malargue»\"},{\"id\":448,\"nombre\":\"CENTRO PROVINCIAL ADICCIONES «San Rafael»\"},{\"id\":454,\"nombre\":\"CENTRO PROVINCIAL ADICCIONES «Tejada Gomez»\"},{\"id\":455,\"nombre\":\"CENTRO PROVINCIAL ADICCIONES «Tunuyan»\"},{\"id\":447,\"nombre\":\"CENTRO PROVINCIAL ADICCIONES «Zona Este»\"},{\"id\":354,\"nombre\":\"Centro Sanitario Vacunatorio Central (Prog. Prov. de Inmunizaciones)\"},{\"id\":363,\"nombre\":\"C.I.C. Nº 901 «Dr. Schervoski»\"},{\"id\":4,\"nombre\":\"C.I.C. Nº 902 «Dr. Arturo Illia» (antes C.S. Nº 301)\"},{\"id\":382,\"nombre\":\"C.I.C. Nº 903 «El Borbollón»\"},{\"id\":103,\"nombre\":\"C.I.C. Nº 904 «Malvinas Argentinas» (antes  C.S. Nº 216)\"},{\"id\":403,\"nombre\":\"C.I.C. Nº 905 «Costa de Araujo»\"},{\"id\":399,\"nombre\":\"C.I.C. Nº 906 «Jocolí»\"},{\"id\":40,\"nombre\":\"C.I.C. Nº 907 «Barrio 25 de Mayo» (antes C.S. Nº 166)\"},{\"id\":333,\"nombre\":\"C.I.C. Nº 910 «Palmira»\"},{\"id\":164,\"nombre\":\"C.I.C. Nº 911 «Santa Maria de Oro» (antes C.S. Nº 148)\"},{\"id\":163,\"nombre\":\"C.I.C. Nº 912 «La Reducción» (antes C.S. Nº 343)\"},{\"id\":394,\"nombre\":\"C.I.C. Nº 913 «La Colonia» (antes C.S. Nº 169)\"},{\"id\":437,\"nombre\":\"C.I.C. Nº 914 «Barrio Las Colonias»\"},{\"id\":281,\"nombre\":\"C.I.C. Nº 916 «Tito Álvarez Casaldi» (antes C.S. Nº 358)\"},{\"id\":328,\"nombre\":\"C.I.C. Nº 917 «Barrio Venezuela» (antes C.S. Nº 235)\"},{\"id\":327,\"nombre\":\"C.I.C. Nº 918 «Vista Flores»\"},{\"id\":90,\"nombre\":\"C.I.C. Nº 919 «Barrio San Carlos» (antes C.S. Nº 157)\"},{\"id\":111,\"nombre\":\"C.I.C. Nº 921 «Los Barriales» (antes C.S. Nº 63)\"},{\"id\":383,\"nombre\":\"C.I.C. Nº 922 «Tres Porteñas»\"},{\"id\":390,\"nombre\":\"C.I.C. Nº 923 «Fray Luis Beltrán»\"},{\"id\":381,\"nombre\":\"C.I.C. Nº 924 «El Algarrobal» (antes P.S. Jorge Newbery)\"},{\"id\":416,\"nombre\":\"C.I.C. Nº 925 «El Plumerillo»\"},{\"id\":436,\"nombre\":\"C.I.C. Nº 926 «Barrio Boggero»\"},{\"id\":460,\"nombre\":\"COMPLEJO PENITENCIARIO II SAN FELI'PE\"},{\"id\":375,\"nombre\":\"Consultorio Móvil de Atención Primaria de la Salud\"},{\"id\":338,\"nombre\":\"Coordinación Departamental de General Alvear\"},{\"id\":339,\"nombre\":\"Coordinación Departamental de Godoy Cruz\"},{\"id\":340,\"nombre\":\"Coordinación Departamental de Guaymallén\"},{\"id\":341,\"nombre\":\"Coordinación Departamental de Junín\"},{\"id\":342,\"nombre\":\"Coordinación Departamental de La Paz\"},{\"id\":343,\"nombre\":\"Coordinación Departamental de Las Heras\"},{\"id\":344,\"nombre\":\"Coordinación Departamental de Lavalle\"},{\"id\":345,\"nombre\":\"Coordinación Departamental de Luján de Cuyo\"},{\"id\":346,\"nombre\":\"Coordinación Departamental de Maipú\"},{\"id\":357,\"nombre\":\"Coordinación Departamental de Malargüe\"},{\"id\":347,\"nombre\":\"Coordinación Departamental de Rivadavia\"},{\"id\":337,\"nombre\":\"Coordinación Departamental de Salud de Capital\"},{\"id\":348,\"nombre\":\"Coordinación Departamental de San Carlos\"},{\"id\":349,\"nombre\":\"Coordinación Departamental de San Martín\"},{\"id\":350,\"nombre\":\"Coordinación Departamental de San Rafael\"},{\"id\":351,\"nombre\":\"Coordinación Departamental de Santa Rosa\"},{\"id\":352,\"nombre\":\"Coordinación Departamental de Tunuyán\"},{\"id\":353,\"nombre\":\"Coordinación Departamental de Tupungato\"},{\"id\":418,\"nombre\":\"Departamento de Odontología\"},{\"id\":419,\"nombre\":\"Dirección de Hospitales\"},{\"id\":359,\"nombre\":\"Dirección de Prevención Sanitaria y Microhospital – Municipalidad de Guaymallen\"},{\"id\":405,\"nombre\":\"Dirección de Prevención y Promoción de la Salud \"},{\"id\":438,\"nombre\":\"\\tDIRECCION DE SALUD MENTAL Y ADICCIONES\"},{\"id\":374,\"nombre\":\"Dirección de Salud – Municipalidad de Godoy Cruz\"},{\"id\":360,\"nombre\":\"Dirección de salud - Municipalidad de las Heras\"},{\"id\":365,\"nombre\":\"Dirección de Salud - Municipalidad de Maipú\"},{\"id\":362,\"nombre\":\"Dirección de salud - Municipalidad de San Rafael\"},{\"id\":385,\"nombre\":\"Dirección de Salud – Municipalidad de Santa Rosa\"},{\"id\":376,\"nombre\":\"Dirección General de Epidemiología y ambiente saludable\"},{\"id\":393,\"nombre\":\"Equipo Preventivo y Asistencial de Salud - EPAS\"},{\"id\":401,\"nombre\":\"Facultad de Odontología UNCuyo\"},{\"id\":275,\"nombre\":\"Hospital Alfredo Metraux\"},{\"id\":294,\"nombre\":\"Hospital Antonio Scaravelli\"},{\"id\":114,\"nombre\":\"Hospital Arturo Illia\"},{\"id\":457,\"nombre\":\"HOSPITAL CARLOS PEREYRA\"},{\"id\":397,\"nombre\":\"Hospital Central\"},{\"id\":434,\"nombre\":\"Hospital del Niño Jesus\"},{\"id\":429,\"nombre\":\"Hospital de niños de la Santisima Trinidad\"},{\"id\":433,\"nombre\":\"Hospital de niños Dr. Orlando Alassia\"},{\"id\":432,\"nombre\":\"Hospital de niños Vilela\"},{\"id\":424,\"nombre\":\"Hospital de trauma y emergencias Dr. Federico Abete\"},{\"id\":42,\"nombre\":\"Hospital Diego Paroissien\"},{\"id\":148,\"nombre\":\"Hospital Domingo Sícoli\"},{\"id\":263,\"nombre\":\"Hospital Dr. Alfredo Italo Perrupato\"},{\"id\":173,\"nombre\":\"Hospital Dr. Carlos F. Saporiti\"},{\"id\":377,\"nombre\":\"Hospital Dr. Ramón Carrillo\"},{\"id\":428,\"nombre\":\"Hospital el cruce\"},{\"id\":69,\"nombre\":\"Hospital El Sauce\"},{\"id\":96,\"nombre\":\"Hospital Enfermeros Argentinos (General Alvear)\"},{\"id\":70,\"nombre\":\"Hospital Eva Perón\"},{\"id\":282,\"nombre\":\"Hospital Fernando Arenas Raffo\"},{\"id\":301,\"nombre\":\"Hospital General Las Heras\"},{\"id\":421,\"nombre\":\"Hospital GUTIÉRREZ\"},{\"id\":16,\"nombre\":\"Hospital Héctor E. Gailhac\"},{\"id\":427,\"nombre\":\"Hospital interzonal especializado de agudos Superiora Sor Maria Ludovica\"},{\"id\":5,\"nombre\":\"Hospital José Néstor Lencinas\"},{\"id\":423,\"nombre\":\"Hospital Juan P. Garrahan\"},{\"id\":121,\"nombre\":\"Hospital Luis Chrabalowski\"},{\"id\":45,\"nombre\":\"Hospital Luis Lagomaggiore\"},{\"id\":426,\"nombre\":\"Hospital materno infantil Dr. Tetamanti\"},{\"id\":425,\"nombre\":\"Hospital Nacional Profesor Alejandro Posadas\"},{\"id\":30,\"nombre\":\"Hospital Pediátrico “Dr. Humberto J Notti”\"},{\"id\":422,\"nombre\":\"Hospital PEDRO de ELIZALDE\"},{\"id\":435,\"nombre\":\"Hospital provincial de Neuquén - Dr. Eduardo Castro Rendon\"},{\"id\":197,\"nombre\":\"Hospital Regional Malargüe\"},{\"id\":431,\"nombre\":\"Hospital San Roque\"},{\"id\":53,\"nombre\":\"Hospital Teodoro Schestakow\"},{\"id\":244,\"nombre\":\"Hospital Victorino Tagarelli\"},{\"id\":430,\"nombre\":\"Instituto de Cardiologia Juana F. Cabral\"},{\"id\":379,\"nombre\":\"Laboratorio Nº 1 – Coordinación Departamental de Tunuyán\"},{\"id\":2,\"nombre\":\"Micro Hospital Puente de Hierro\"},{\"id\":358,\"nombre\":\"Municipalidad de la Capital - Dirección de Salud\"},{\"id\":400,\"nombre\":\"Municipalidad de Lavalle \"},{\"id\":386,\"nombre\":\"Otros\"},{\"id\":458,\"nombre\":\"PENITENCIARIA PROVINCIAL\"},{\"id\":316,\"nombre\":\"Posta del Ladrillero\"},{\"id\":334,\"nombre\":\"Posta «La Josefa» (se atiende en escuela)\"},{\"id\":94,\"nombre\":\"Posta Nº 504 «Los Campamentos»\"},{\"id\":95,\"nombre\":\"Posta Nº 516 «La Marzolina»\"},{\"id\":71,\"nombre\":\"Posta Nº 527 «Las Dorcas»\"},{\"id\":324,\"nombre\":\"Posta Nº 528 «El Nevado»\"},{\"id\":246,\"nombre\":\"Posta Sanitaria «Carapacho»\"},{\"id\":330,\"nombre\":\"Posta Sanitaria N° 548 «El Topón»\"},{\"id\":35,\"nombre\":\"Posta Sanitaria N° 549 «El Challao»\"},{\"id\":136,\"nombre\":\"Posta Sanitaria Nº 200 «San Gabriel»\"},{\"id\":137,\"nombre\":\"Posta Sanitaria Nº 201 «Colonia Italia»\"},{\"id\":241,\"nombre\":\"Posta Sanitaria Nº 312 «Casas Viejas»\"},{\"id\":242,\"nombre\":\"Posta Sanitaria Nº 313 «Calise»\"},{\"id\":243,\"nombre\":\"Posta Sanitaria Nº 314 «Furlotti»\"},{\"id\":140,\"nombre\":\"Posta Sanitaria Nº 502 «El Plumero»\"},{\"id\":283,\"nombre\":\"Posta Sanitaria Nº 505 «Alejo Sosa»\"},{\"id\":141,\"nombre\":\"Posta Sanitaria Nº 506 «El Cavadito»\"},{\"id\":142,\"nombre\":\"Posta Sanitaria Nº 507 «El Retiro»\"},{\"id\":143,\"nombre\":\"Posta Sanitaria Nº 508 «El Carmen»\"},{\"id\":144,\"nombre\":\"Posta Sanitaria Nº 509 «San Pedro»\"},{\"id\":145,\"nombre\":\"Posta Sanitaria Nº 510 «El Paramillo»\"},{\"id\":146,\"nombre\":\"Posta Sanitaria Nº 511 «Los Médanos»\"},{\"id\":147,\"nombre\":\"Posta Sanitaria Nº 512 «Alto Retamo»\"},{\"id\":99,\"nombre\":\"Posta Sanitaria Nº 515 «Sol y Sierra»\"},{\"id\":174,\"nombre\":\"Posta Sanitaria Nº 517 «San Cayetano»\"},{\"id\":175,\"nombre\":\"Posta Sanitaria Nº 518 «San Francisco»\"},{\"id\":319,\"nombre\":\"Posta Sanitaria Nº 520 «Las Vegas»\"},{\"id\":321,\"nombre\":\"Posta Sanitaria Nº 521 «Cacheuta Norte»\"},{\"id\":320,\"nombre\":\"Posta Sanitaria Nº 522 «Las Avispas»\"},{\"id\":318,\"nombre\":\"Posta Sanitaria Nº 523 «Novero»\"},{\"id\":314,\"nombre\":\"Posta Sanitaria Nº 530 «Ignacio Galarraga»\"},{\"id\":216,\"nombre\":\"Posta Sanitaria Nº 536 «Pobre Diablo»\"},{\"id\":217,\"nombre\":\"Posta Sanitaria Nº 537 «Palermo Chico»\"},{\"id\":373,\"nombre\":\"Posta Sanitaria Nº 539 «Santa Lucía»\"},{\"id\":80,\"nombre\":\"Posta Sanitaria Nº 546 «Costa Esperanza»\"},{\"id\":388,\"nombre\":\"Posta Sanitaria Nº 547 «25 de julio»\"},{\"id\":361,\"nombre\":\"Posta Sanitaria Nº 551 «Dora Sonana»\"},{\"id\":332,\"nombre\":\"Posta Sanitaria Nº 552 «El Espino»\"},{\"id\":336,\"nombre\":\"Posta Sanitaria Nº 553 «Los alamitos»\"},{\"id\":329,\"nombre\":\"Posta Sanitaria Nº 554 «Barrio San Isidro»\"},{\"id\":364,\"nombre\":\"Posta Sanitaria Nº 555 «Campo Los Andes»\"},{\"id\":371,\"nombre\":\"Posta Sanitaria Nº 557 «Arroyo de los Caballos»\"},{\"id\":331,\"nombre\":\"Posta Sanitaria Nº 560 «Obreros Rurales de Santa María»\"},{\"id\":420,\"nombre\":\"Posta Sanitaria Nº 564 «Los Lotes Barraqueros»\"},{\"id\":367,\"nombre\":\"Posta Sanitaria «Valle Grande»\"},{\"id\":417,\"nombre\":\"Servicio asistencial móvil de Lavalle\"},{\"id\":398,\"nombre\":\"Servicio de Emergencia Coordinado\"},{\"id\":391,\"nombre\":\"UGSP\"},{\"id\":456,\"nombre\":\"UNIDAD DE INTERNACION EN CRISIS\"},{\"id\":459,\"nombre\":\"UNIDAD III - PENAL DE MUJERES\"},{\"id\":402,\"nombre\":\"Universidad Nacional de Cuyo\"},{\"id\":355,\"nombre\":\"Vacunatorio Central Malargüe\"},{\"id\":380,\"nombre\":\"Vacunatorio San Martín\"}]");
});
