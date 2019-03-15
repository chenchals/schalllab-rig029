

declare WTCH_PD_SCHMITT();

process WTCH_PD_SCHMITT()
{
  declare float pdValL   = 0;
  declare float pdValR   = 0;
  pdThresh = 500;
  while (1)
  {
    pdValL = atable(PD_Left_channel);
    pdValR = atable(PD_Right_channel);
    if (pdValL < pdThresh && PD_TRIG_L == 0)
    {
      PD_TRIG_L = 1;
      spawn SEND_EVT(EVT_PD_TRIGGER_LEFT_);
    }
    else if (pdValL > pdThresh && PD_TRIG_L == 1)
    {
      PD_TRIG_L = 0;
    }
    // PD Right
    if (pdValR < pdThresh && PD_TRIG_R == 0)
    {
      PD_TRIG_R = 1;
      spawn SEND_EVT(EVT_PD_TRIGGER_RIGHT_);
    }
    else if (pdValR > pdThresh && PD_TRIG_R == 1)
    {
      PD_TRIG_R = 0;
    }
    //printf("%d,%d,%d,%d,%d\n",Trl_number,pdValL,pdValR,PD_TRIG_L,PD_TRIG_R);
    //writef("pdValsSc.csv %d,%d,%d,%d,%d\n",Trl_number,pdValL,pdValR,PD_TRIG_L,PD_TRIG_R);
    nexttick;
  }
}
