<?php

namespace Database\Seeders\Update;

use App\Models\Admin\BasicSettings;
use Exception;
use Illuminate\Database\Seeder;

class BasicSettingsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()

    {
        $basicSettings = BasicSettings::first();
        $mail_config = (array)$basicSettings->mail_config;

        if (!array_key_exists('from', $mail_config)) {
            $mail_config['from'] = $mail_config['username'] ?? '';
        }

        $data = [
            'web_version'   => "5.2.0",
            'mail_config'                   => (object)$mail_config,
            'user_pin_verification'         => true,
            'agent_pin_verification'        => true,
            'merchant_pin_verification'     => true,
        ];

        $basicSettings->update($data);

        //update language values
        try{
            update_project_localization_data();
        }catch(Exception $e) {
            // handle error
        }
    }
}
