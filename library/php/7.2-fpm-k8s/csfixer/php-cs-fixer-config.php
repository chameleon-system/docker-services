<?php

return PhpCsFixer\Config::create()
    ->setRules(array(
        '@Symfony' => true,
        'phpdoc_to_comment' => false,       # This rule would remove docblocks for constants, which would cause PHPStorm
                                            # to no longer recognize e.g. deprecation notices.
        'phpdoc_var_without_name' => false, # This rule would remove variable names from docblocks in methods, which
                                            # would cause PHPStorm to no longer recognize the variable type
                                            # (see https://github.com/FriendsOfPHP/PHP-CS-Fixer/issues/3112)
    ))
;