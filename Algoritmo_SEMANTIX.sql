/*
||=====================================================================//
|| AUTOR       : RODRIGO ROSENO DE SANTANA
|| VERSAO      : 1.0
|| DESCRICAO   : ALGORITMO DE PROXIMIDADE SEMANTIX
|| OBS         : ESSE ALGORITMO SÓ PODE SER EXECUTADO APÓS A CRIAÇÃO 
||               DO ARQUIVO ANTERIOR BD_SEMANTI.sql
||               IRÁ OBTER COMO RESULTADO A PROXIMIDADE ENTRE USUÁRIOS
||=====================================================================//
*/

DECLARE
  meu_codigo NUMBER:=1;
  meu_nome   VARCHAR2(60);
  distancia  NUMBER(20,15);
  
  perto_codigo    NUMBER;
  perto_nome      VARCHAR2(60);
  perto_distancia NUMBER(20,15);
 
  TYPE t_coluna IS VARRAY(2) OF NUMBER(10,7);
  TYPE t_matriz IS VARRAY(2) OF t_coluna;
  matriz t_matriz; 
  
  posicao INTEGER:=1;
  
BEGIN
  
  matriz:=t_matriz(
            t_coluna(0,0),
            t_coluna(0,0)
  );
  SELECT nm_usuario,latitude,longitude INTO meu_nome,matriz(1)(1),matriz(1)(2) 
  FROM T_BD_DESAFIO WHERE cd_usuario=meu_codigo;
  
  FOR linha IN (SELECT * FROM T_BD_DESAFIO WHERE cd_usuario<>meu_codigo AND latitude<>0)
  LOOP
    matriz(2)(1):=linha.latitude;
    matriz(2)(2):=linha.longitude;
    
    distancia:=SQRT(
                 POWER(matriz(1)(1)-matriz(2)(1),2)+POWER(matriz(1)(2)-matriz(2)(2),2)
               );
			   
    IF posicao=1 THEN
      perto_codigo:=linha.cd_usuario;
      perto_nome:=linha.nm_usuario;
      perto_distancia:=distancia;
            
    ELSE
      IF distancia<perto_distancia THEN
        perto_codigo:=linha.cd_usuario;
        perto_nome:=linha.nm_usuario;
        perto_distancia:=distancia;     
      END IF;
    END IF;
    posicao:=posicao+1;
  END LOOP;
  
  DBMS_OUTPUT.put_line('Eu sou:  '||meu_nome);
  DBMS_OUTPUT.put_line('Quem está mais perto na rede social:'||perto_nome||' com km de distancia:'||perto_distancia*125);
END;