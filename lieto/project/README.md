# Progetto SOAR

Per eseguire gli agenti basta caricarli su `SoarJavaDebugger`.  
Gli agenti `escape.soar` e `escape_all_rl.soar` riescono sempre a fuggire. Mentre `escape_one_action.soar` e `escape_all_rl_one.soar` è improbabile che trovino la soluzione al primo tentativo, pertanto sarà necessario eseguire più volte gli agenti riinizializzando l'ambiente con `init-soar` ogni volta.