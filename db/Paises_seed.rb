# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarPaises < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
Pais.create([
  { :nombre => "Argentina",
    :nombre_largo => "República Argentina" },
  { :nombre => "Afganistán",
    :nombre_largo => "República Islámica de Afganistán" },
  { :nombre => "Albania",
    :nombre_largo => "República de Albania" },
  { :nombre => "Alemania",
    :nombre_largo => "República Federal de Alemania" },
  { :nombre => "Andorra",
    :nombre_largo => "Principado de Andorra" },
  { :nombre => "Angola",
    :nombre_largo => "República de Angola" },
  { :nombre => "Antigua y Barbuda",
    :nombre_largo => "Antigua y Barbuda" },
  { :nombre => "Arabia Saudita",
    :nombre_largo => "Reino de Arabia Saudita" },
  { :nombre => "Argelia",
    :nombre_largo => "República Argelina Democrática y Popular" },
  { :nombre => "Armenia",
    :nombre_largo => "República de Armenia" },
  { :nombre => "Australia",
    :nombre_largo => "Australia" },
  { :nombre => "Austria",
    :nombre_largo => "República de Austria" },
  { :nombre => "Azerbaiyán",
    :nombre_largo => "República de Azerbaiyán" },
  { :nombre => "Bahamas",
    :nombre_largo => "Commonwealth de las Bahamas" },
  { :nombre => "Bahrein",
    :nombre_largo => "Reino de Bahrein" },
  { :nombre => "Bangladesh",
    :nombre_largo => "República Popular de Bangladesh" },
  { :nombre => "Barbados",
    :nombre_largo => "Barbados" },
  { :nombre => "Belarús",
    :nombre_largo => "República de Belarús" },
  { :nombre => "Bélgica",
    :nombre_largo => "Reino de Bélgica" },
  { :nombre => "Belice",
    :nombre_largo => "Belice" },
  { :nombre => "Benin",
    :nombre_largo => "República de Benin" },
  { :nombre => "Bhután",
    :nombre_largo => "Reino de Bhután" },
  { :nombre => "Bolivia",
    :nombre_largo => "Estado Plurinacional de Bolivia" },
  { :nombre => "Bosnia y Herzegovina",
    :nombre_largo => "Bosnia y Herzegovina" },
  { :nombre => "Botswana",
    :nombre_largo => "República de Botswana" },
  { :nombre => "Brasil ",
    :nombre_largo => "República Federativa del Brasil" },
  { :nombre => "Brunei Darussalam",
    :nombre_largo => "Brunei Darussalam" },
  { :nombre => "Bulgaria",
    :nombre_largo => "República de Bulgaria" },
  { :nombre => "Burkina Faso",
    :nombre_largo => "Burkina Faso" },
  { :nombre => "Burundi",
    :nombre_largo => "República de Burundi" },
  { :nombre => "Cabo Verde",
    :nombre_largo => "República de Cabo Verde" },
  { :nombre => "Camboya",
    :nombre_largo => "Reino de Camboya" },
  { :nombre => "Camerún",
    :nombre_largo => "República del Camerún" },
  { :nombre => "Canadá",
    :nombre_largo => "Canadá" },
  { :nombre => "Chad",
    :nombre_largo => "República del Chad" },
  { :nombre => "República Checa",
    :nombre_largo => "República Checa" },
  { :nombre => "Chile",
    :nombre_largo => "República de Chile" },
  { :nombre => "China",
    :nombre_largo => "República Popular China" },
  { :nombre => "Chipre",
    :nombre_largo => "República de Chipre" },
  { :nombre => "Colombia",
    :nombre_largo => "República de Colombia" },
  { :nombre => "Comoras",
    :nombre_largo => "Unión de las Comoras" },
  { :nombre => "Congo",
    :nombre_largo => "República del Congo" },
  { :nombre => "República Democrática del Congo",
    :nombre_largo => "República Democrática del Congo" },
  { :nombre => "República Popular Democrática de Corea",
    :nombre_largo => "República Popular Democrática de Corea" },
  { :nombre => "República de Corea",
    :nombre_largo => "República de Corea" },
  { :nombre => "Costa Rica",
    :nombre_largo => "República de Costa Rica" },
  { :nombre => "Côte d'Ivoire",
    :nombre_largo => "República de Côte d'Ivoire" },
  { :nombre => "Croacia",
    :nombre_largo => "República de Croacia" },
  { :nombre => "Cuba",
    :nombre_largo => "República de Cuba" },
  { :nombre => "Dinamarca",
    :nombre_largo => "Reino de Dinamarca" },
  { :nombre => "Djibouti",
    :nombre_largo => "República de Djibouti" },
  { :nombre => "Dominica",
    :nombre_largo => "Commonwealth de Dominica" },
  { :nombre => "Ecuador",
    :nombre_largo => "República del Ecuador" },
  { :nombre => "Egipto",
    :nombre_largo => "República Árabe de Egipto" },
  { :nombre => "El Salvador",
    :nombre_largo => "República de El Salvador" },
  { :nombre => "Emiratos Árabes Unidos",
    :nombre_largo => "Emiratos Árabes Unidos" },
  { :nombre => "Eritrea",
    :nombre_largo => "Eritrea" },
  { :nombre => "Eslovaquia",
    :nombre_largo => "República Eslovaca" },
  { :nombre => "Eslovenia",
    :nombre_largo => "República de Eslovenia" },
  { :nombre => "España",
    :nombre_largo => "Reino de España" },
  { :nombre => "Estados Unidos de América",
    :nombre_largo => "Estados Unidos de América" },
  { :nombre => "Estonia",
    :nombre_largo => "República de Estonia" },
  { :nombre => "Etiopía",
    :nombre_largo => "República Democrática Federal de Etiopía" },
  { :nombre => "Fiji",
    :nombre_largo => "República de las Islas Fiji" },
  { :nombre => "Filipinas",
    :nombre_largo => "República de Filipinas" },
  { :nombre => "Finlandia",
    :nombre_largo => "República de Finlandia" },
  { :nombre => "Francia",
    :nombre_largo => "República Francesa" },
  { :nombre => "Gabón",
    :nombre_largo => "República Gabonesa" },
  { :nombre => "Gambia",
    :nombre_largo => "República de Gambia" },
  { :nombre => "Georgia",
    :nombre_largo => "Georgia" },
  { :nombre => "Ghana",
    :nombre_largo => "República de Ghana" },
  { :nombre => "Granada",
    :nombre_largo => "Granada" },
  { :nombre => "Grecia",
    :nombre_largo => "República Helénica" },
  { :nombre => "Guatemala",
    :nombre_largo => "República de Guatemala" },
  { :nombre => "Guinea",
    :nombre_largo => "República de Guinea" },
  { :nombre => "Guinea-Bissau",
    :nombre_largo => "República de Guinea-Bissau" },
  { :nombre => "Guinea Ecuatorial",
    :nombre_largo => "República de Guinea Ecuatorial" },
  { :nombre => "Guyana",
    :nombre_largo => "República de Guyana" },
  { :nombre => "Haití",
    :nombre_largo => "República de Haití" },
  { :nombre => "Honduras",
    :nombre_largo => "República de Honduras" },
  { :nombre => "Hungría",
    :nombre_largo => "República de Hungría" },
  { :nombre => "India",
    :nombre_largo => "República de la India" },
  { :nombre => "Indonesia",
    :nombre_largo => "República de Indonesia" },
  { :nombre => "Irán",
    :nombre_largo => "República Islámica del Irán" },
  { :nombre => "Iraq",
    :nombre_largo => "República del Iraq" },
  { :nombre => "Irlanda",
    :nombre_largo => "Irlanda" },
  { :nombre => "Islandia",
    :nombre_largo => "República de Islandia" },
  { :nombre => "Israel",
    :nombre_largo => "Estado de Israel" },
  { :nombre => "Italia",
    :nombre_largo => "República Italiana" },
  { :nombre => "Jamaica",
    :nombre_largo => "Jamaica" },
  { :nombre => "Japón",
    :nombre_largo => "Japón" },
  { :nombre => "Jordania",
    :nombre_largo => "Reino Hachemita de Jordania" },
  { :nombre => "Kazajstán",
    :nombre_largo => "República de Kazajstán" },
  { :nombre => "Kenya",
    :nombre_largo => "República de Kenya" },
  { :nombre => "Kirguistán",
    :nombre_largo => "República Kirguisa" },
  { :nombre => "Kiribati",
    :nombre_largo => "República de Kiribati" },
  { :nombre => "Kuwait",
    :nombre_largo => "Estado de Kuwait" },
  { :nombre => "República Democrática Popular Lao",
    :nombre_largo => "República Democrática Popular Lao" },
  { :nombre => "Lesotho",
    :nombre_largo => "Reino de Lesotho" },
  { :nombre => "Letonia",
    :nombre_largo => "República de Letonia" },
  { :nombre => "Líbano",
    :nombre_largo => "República Libanesa" },
  { :nombre => "Liberia",
    :nombre_largo => "República de Liberia" },
  { :nombre => "Jamahiriya Árabe Libia",
    :nombre_largo => "Jamahiriya Árabe Libia Popular y Socialista" },
  { :nombre => "Liechtenstein",
    :nombre_largo => "Principado de Liechtenstein" },
  { :nombre => "Lituania",
    :nombre_largo => "República de Lituania" },
  { :nombre => "Luxemburgo",
    :nombre_largo => "Gran Ducadao de Luxemburgo" },
  { :nombre => "La ex República Yugoslava de Macedonia",
    :nombre_largo => "La ex República Yugoslava de Macedonia" },
  { :nombre => "Madagascar",
    :nombre_largo => "República de Madagascar" },
  { :nombre => "Malasia",
    :nombre_largo => "Malasia" },
  { :nombre => "Malawi",
    :nombre_largo => "República de Malawi" },
  { :nombre => "Maldivas",
    :nombre_largo => "República de Maldivas" },
  { :nombre => "Malí",
    :nombre_largo => "República de Malí" },
  { :nombre => "Malta",
    :nombre_largo => "República de Malta" },
  { :nombre => "Marruecos",
    :nombre_largo => "Reino de Marruecos" },
  { :nombre => "Islas Marshall",
    :nombre_largo => "República de las Islas Marshall" },
  { :nombre => "Mauricio",
    :nombre_largo => "República de Mauricio" },
  { :nombre => "Mauritania",
    :nombre_largo => "República Islámica de Mauritania" },
  { :nombre => "México",
    :nombre_largo => "Estados Unidos Mexicanos" },
  { :nombre => "Micronesia",
    :nombre_largo => "Estados Federados de Micronesia" },
  { :nombre => "República de Moldova",
    :nombre_largo => "República de Moldova" },
  { :nombre => "Mónaco",
    :nombre_largo => "Principado de Mónaco" },
  { :nombre => "Mongolia",
    :nombre_largo => "Mongolia" },
  { :nombre => "Montenegro",
    :nombre_largo => "Montenegro" },
  { :nombre => "Mozambique",
    :nombre_largo => "República de Mozambique" },
  { :nombre => "Myanmar",
    :nombre_largo => "Unión de Myanmar" },
  { :nombre => "Namibia",
    :nombre_largo => "República de Namibia" },
  { :nombre => "Nauru",
    :nombre_largo => "República de Nauru" },
  { :nombre => "Nepal",
    :nombre_largo => "República Democrática Federal de Nepal" },
  { :nombre => "Nicaragua",
    :nombre_largo => "República de Nicaragua" },
  { :nombre => "Níger",
    :nombre_largo => "República del Níger" },
  { :nombre => "Nigeria",
    :nombre_largo => "República Federal de Nigeria" },
  { :nombre => "Noruega",
    :nombre_largo => "Reino de Noruega" },
  { :nombre => "Nueva Zelandia",
    :nombre_largo => "Nueva Zelandia" },
  { :nombre => "Omán",
    :nombre_largo => "Sultanía de Omán" },
  { :nombre => "Países Bajos",
    :nombre_largo => "Reino de los Países Bajos" },
  { :nombre => "Pakistán",
    :nombre_largo => "República Islámica del Pakistán" },
  { :nombre => "Palau",
    :nombre_largo => "República de Palau" },
  { :nombre => "Panamá",
    :nombre_largo => "República de Panamá" },
  { :nombre => "Papua Nueva Guinea",
    :nombre_largo => "Papua Nueva Guinea" },
  { :nombre => "Paraguay",
    :nombre_largo => "República del Paraguay" },
  { :nombre => "Perú",
    :nombre_largo => "República del Perú" },
  { :nombre => "Polonia",
    :nombre_largo => "República de Polonia" },
  { :nombre => "Portugal",
    :nombre_largo => "República Portuguesa" },
  { :nombre => "Qatar",
    :nombre_largo => "Estado de Qatar" },
  { :nombre => "Reino Unido (G. Bretaña e Irlanda N)",
    :nombre_largo => "Reino Unido de Gran Bretaña e Irlanda del Norte" },
  { :nombre => "República Centroafricana",
    :nombre_largo => "República Centroafricana" },
  { :nombre => "República Dominicana",
    :nombre_largo => "República Dominicana" },
  { :nombre => "Rumania",
    :nombre_largo => "Rumania" },
  { :nombre => "Federación de Rusia",
    :nombre_largo => "Federación de Rusia" },
  { :nombre => "Rwanda",
    :nombre_largo => "República de Rwanda" },
  { :nombre => "Saint Kitts y Nevis",
    :nombre_largo => "Saint Kitts y Nevis" },
  { :nombre => "Islas Salomón",
    :nombre_largo => "Islas Salomón" },
  { :nombre => "Samoa",
    :nombre_largo => "Estado Independiente de Samoa" },
  { :nombre => "San Marino",
    :nombre_largo => "República de San Marino" },
  { :nombre => "Santa Lucía",
    :nombre_largo => "Santa Lucía" },
  { :nombre => "Santa Sede",
    :nombre_largo => "Santa Sede" },
  { :nombre => "Santo Tomé y Príncipe",
    :nombre_largo => "República Democrática de Santo Tomé y Príncipe" },
  { :nombre => "San Vicente y las Granadinas",
    :nombre_largo => "San Vicente y las Granadinas" },
  { :nombre => "Senegal",
    :nombre_largo => "República del Senegal" },
  { :nombre => "Serbia",
    :nombre_largo => "República de Serbia" },
  { :nombre => "Seychelles",
    :nombre_largo => "República de Seychelles" },
  { :nombre => "Sierra Leona",
    :nombre_largo => "República de Sierra Leona" },
  { :nombre => "Singapur",
    :nombre_largo => "República de Singapur" },
  { :nombre => "República Árabe Siria",
    :nombre_largo => "República Árabe Siria" },
  { :nombre => "Somalía",
    :nombre_largo => "República Somalí" },
  { :nombre => "Sri Lanka",
    :nombre_largo => "República Socialista Democrática de Sri Lanka" },
  { :nombre => "Sudáfrica",
    :nombre_largo => "República de Sudáfrica" },
  { :nombre => "Sudán",
    :nombre_largo => "República del Sudán" },
  { :nombre => "Suecia",
    :nombre_largo => "Reino de Suecia" },
  { :nombre => "Suiza",
    :nombre_largo => "Confederación Suiza" },
  { :nombre => "Suriname",
    :nombre_largo => "República de Suriname" },
  { :nombre => "Swazilandia",
    :nombre_largo => "Reino de Swazilandia" },
  { :nombre => "Tailandia",
    :nombre_largo => "Reino de Tailandia" },
  { :nombre => "República Unida de Tanzanía",
    :nombre_largo => "República Unida de Tanzanía" },
  { :nombre => "Tayikistán",
    :nombre_largo => "República de Tayikistán" },
  { :nombre => "Timor-Leste",
    :nombre_largo => "República Democrática de Timor-Leste" },
  { :nombre => "Togo",
    :nombre_largo => "República Togolesa" },
  { :nombre => "Tonga",
    :nombre_largo => "Reino de Tonga" },
  { :nombre => "Trinidad y Tabago",
    :nombre_largo => "República de Trinidad y Tabago" },
  { :nombre => "Túnez",
    :nombre_largo => "República de Túnez" },
  { :nombre => "Turkmenistán",
    :nombre_largo => "Turkmenistán" },
  { :nombre => "Turquía",
    :nombre_largo => "República de Turquía" },
  { :nombre => "Tuvalu",
    :nombre_largo => "Tuvalu" },
  { :nombre => "Ucrania",
    :nombre_largo => "Ucrania" },
  { :nombre => "Uganda",
    :nombre_largo => "República de Uganda" },
  { :nombre => "Uruguay",
    :nombre_largo => "República Oriental del Uruguay" },
  { :nombre => "Uzbekistán",
    :nombre_largo => "República de Uzbekistán" },
  { :nombre => "Vanuatu",
    :nombre_largo => "República de Vanuatu" },
  { :nombre => "Venezuela",
    :nombre_largo => "República Bolivariana de Venezuela" },
  { :nombre => "Viet Nam",
    :nombre_largo => "República Socialista de Viet Nam" },
  { :nombre => "Yemen",
    :nombre_largo => "República del Yemen" },
  { :nombre => "Zambia",
    :nombre_largo => "República de Zambia" },
  { :nombre => "Zimbabwe",
    :nombre_largo => "República de Zimbabwe" }
])
