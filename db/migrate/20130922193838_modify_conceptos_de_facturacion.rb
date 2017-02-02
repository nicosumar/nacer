class ModifyConceptosDeFacturacion < ActiveRecord::Migration
  def up
    add_column :conceptos_de_facturacion, :codigo, :string
    add_index :conceptos_de_facturacion, :codigo, :unique => true

    load 'db/ConceptosDeFacturacion_seed.rb'

    puts ConceptoDeFacturacion.all.inspect

    bas_id = ConceptoDeFacturacion.id_del_codigo!("BAS")
    ppn_id = ConceptoDeFacturacion.id_del_codigo!("PPN")
    ppc_id = ConceptoDeFacturacion.id_del_codigo!("PPC")
    ccn_id = ConceptoDeFacturacion.id_del_codigo!("CCN")
    ccc_id = ConceptoDeFacturacion.id_del_codigo!("CCC")
    ambulatorio_id = TipoDeTratamiento.id_del_codigo!("A")
    internacion_id = TipoDeTratamiento.id_del_codigo!("I")
    quirurgico_id = TipoDeTratamiento.id_del_codigo!("Q")

    # Feo, feo, asignación del concepto a las prestaciones por ID.
    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{bas_id}, tipo_de_tratamiento_id = #{ambulatorio_id}
        WHERE id IN (
          258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278,
          279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299,
          300, 301, 302, 309, 310, 311, 312, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328,
          329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348,
          349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369,
          379, 380, 381, 382, 382, 383, 391, 401, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467,
          468, 469, 470, 471, 472, 473, 477, 478, 479, 480, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492,
          493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513,
          514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534,
          535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555,
          556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576,
          577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597,
          598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609
        );
     "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{bas_id}, tipo_de_tratamiento_id = #{internacion_id}
        WHERE id IN (
          303, 305, 307, 384, 385, 386, 387, 390, 392, 474, 475, 476, 481
        );
    "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{bas_id}, tipo_de_tratamiento_id = #{quirurgico_id}
        WHERE id IN (
          304, 306, 308, 313, 314
        );
    "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{ccc_id}, tipo_de_tratamiento_id = #{internacion_id}
        WHERE id IN (
          610, 611, 612, 613, 614, 615, 616, 617, 618
        );
    "
    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{ccc_id}, tipo_de_tratamiento_id = #{quirurgico_id}
        WHERE id IN (
          428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445
        );
    "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{ccn_id}, tipo_de_tratamiento_id = #{internacion_id}
        WHERE id IN (
          402, 403, 404, 405, 406, 407, 446, 447, 448, 449, 450, 451, 452, 453, 454
        );
    "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{ccn_id}, tipo_de_tratamiento_id = #{quirurgico_id}
        WHERE id IN (
          408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427
        );
    "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{ppc_id}, tipo_de_tratamiento_id = #{internacion_id}
        WHERE id IN (
          388, 389
        );
    "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{ppc_id}, tipo_de_tratamiento_id = #{quirurgico_id}
        WHERE id IN (
          393, 394, 395
        );
    "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{ppn_id}, tipo_de_tratamiento_id = #{ambulatorio_id}
        WHERE id IN (
          399, 400
        );
    "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{ppn_id}, tipo_de_tratamiento_id = #{internacion_id}
        WHERE id IN (
          370, 371, 374, 375, 376, 377, 378
        );
    "

    execute "
      UPDATE prestaciones
        SET concepto_de_facturacion_id = #{ppn_id}, tipo_de_tratamiento_id = #{quirurgico_id}
        WHERE id IN (
          372, 373, 396, 397, 398
        );
    "

  end

  def down
    execute "UPDATE prestaciones SET concepto_de_facturacion_id = NULL, tipo_de_tratamiento_id = NULL;"
    ConceptoDeFacturacion.delete_all
    remove_index :conceptos_de_facturacion, :codigo
    remove_column :conceptos_de_facturacion, :codigo
  end
end
