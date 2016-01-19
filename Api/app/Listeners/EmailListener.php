<?php

namespace App\Listeners;

use App\Events\UserHasRegistered;
use Illuminate\Support\Facades\Mail;

class EmailListener
{
    /**
     * Handle the event.
     *
     * @param UserHasRegistered $event
     */
    public function handle(UserHasRegistered $event)
    {

        $user = $event->user;

        Mail::send('mail.template', ['user' => $event->user, 'isPartner' => $event->isPartner], function($m) use ($user) {
            $m->to($user->email)->subject('Activation du compte Both');
        });

    }
}
