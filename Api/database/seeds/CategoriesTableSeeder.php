<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class CategoriesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('categories')->insert([
            'category' => 'KITCHEN_ROOM',
            'name'     => 'Cuisine',
        ]);

        DB::table('categories')->insert([
          'category' => 'ANIMALS',
          'name'     => 'Animals',
        ]);

        DB::table('categories')->insert([
          'category' => 'HOME',
          'name'     => 'Maison',
        ]);

        DB::table('categories')->insert([
           'category' => 'BATHROOM',
           'name'     => 'Salle de bain'
        ]);

        DB::table('categories')->insert([
          'category' => 'WASHING',
          'name'     => 'Linge'
        ]);

    }
}
