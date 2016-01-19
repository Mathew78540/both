<?php

namespace App\Events;

use App\User;
use Illuminate\Queue\SerializesModels;

class UserHasRegistered extends Event
{
    use SerializesModels;

    public $user;
    public $isPartner;

    /**
     * Create a new event instance.
     *
     * @param User $user
     * @param $isPartner
     */
    public function __construct(User $user, $isPartner)
    {
        $this->isPartner = $isPartner;
        $this->user = $user;
    }

    /**
     * Get the channels the event should be broadcast on.
     *
     * @return array
     */
    public function broadcastOn()
    {
        return [];
    }
}
