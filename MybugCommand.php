<?php
class MybugCommand extends CConsoleCommand
{
    public function run($args) {
        $activeRecord = User::model();
        $condition = $activeRecord->getDbCriteria()->addInCondition('id', [1]);
        $activeRecord->updateAll(// here will be used $this->getDbCriteria(true)
            [
                'password' => '123',
            ],
            $condition
        );

        $usersOne = User::model()->findAllByPk([2,3]);// here will be used $this->getDbCriteria(false)
        $usersTwo = User::model()->findAllByPk([2,3]);// here will be used $this->getDbCriteria(true)
        echo count($usersOne) . ':' . count($usersTwo) . PHP_EOL;
    }
}
