/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2007 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

/* This file is designed for use with ISim build 0x9330dbfa */

#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/atana/RTI/dnepr/hw/mm010_dd13/pcores/optical_delay_meter_v1_00_a/test_meter/../hdl/vhdl/meter.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

char *ieee_p_3620187407_sub_4188545914_3620187407(char *, char *, char *, char *, unsigned char );
unsigned char ieee_std_logic_unsigned_equal_stdv_stdv(char *, char *, char *, char *, char *);


static void work_a_1483693708_3306564128_p_0(char *t0)
{
    char t20[16];
    char t21[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    int t22;
    unsigned int t23;

LAB0:    xsi_set_current_line(45, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4100);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(46, ng0);
    t4 = (t0 + 724U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(50, ng0);
    t2 = (t0 + 1164U);
    t4 = *((char **)t2);
    t17 = (11 - 10);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t2 = (t4 + t19);
    t8 = ((IEEE_P_2592010699) + 2224);
    t11 = (t21 + 0U);
    t12 = (t11 + 0U);
    *((int *)t12) = 10;
    t12 = (t11 + 4U);
    *((int *)t12) = 0;
    t12 = (t11 + 8U);
    *((int *)t12) = -1;
    t22 = (0 - 10);
    t23 = (t22 * -1);
    t23 = (t23 + 1);
    t12 = (t11 + 12U);
    *((unsigned int *)t12) = t23;
    t5 = xsi_base_array_concat(t5, t20, t8, (char)97, t2, t21, (char)99, (unsigned char)2, (char)101);
    t12 = (t0 + 4232);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    memcpy(t16, t5, 12U);
    xsi_driver_first_trans_fast(t12);
    xsi_set_current_line(51, ng0);
    t2 = (t0 + 1340U);
    t4 = *((char **)t2);
    t17 = (11 - 10);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t2 = (t4 + t19);
    t8 = ((IEEE_P_2592010699) + 2224);
    t11 = (t21 + 0U);
    t12 = (t11 + 0U);
    *((int *)t12) = 10;
    t12 = (t11 + 4U);
    *((int *)t12) = 0;
    t12 = (t11 + 8U);
    *((int *)t12) = -1;
    t22 = (0 - 10);
    t23 = (t22 * -1);
    t23 = (t23 + 1);
    t12 = (t11 + 12U);
    *((unsigned int *)t12) = t23;
    t5 = xsi_base_array_concat(t5, t20, t8, (char)97, t2, t21, (char)99, (unsigned char)2, (char)101);
    t12 = (t0 + 4268);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    memcpy(t16, t5, 12U);
    xsi_driver_first_trans_fast(t12);

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(47, ng0);
    t4 = (t0 + 6476);
    t12 = (t0 + 4232);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    memcpy(t16, t4, 12U);
    xsi_driver_first_trans_fast(t12);
    xsi_set_current_line(48, ng0);
    t2 = (t0 + 6488);
    t5 = (t0 + 4268);
    t8 = (t5 + 32U);
    t11 = *((char **)t8);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 12U);
    xsi_driver_first_trans_fast(t5);
    goto LAB9;

}

static void work_a_1483693708_3306564128_p_1(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(56, ng0);

LAB3:    t1 = (t0 + 1164U);
    t2 = *((char **)t1);
    t3 = (11 - 11);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 4304);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast_port(t8);

LAB2:    t13 = (t0 + 4108);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1483693708_3306564128_p_2(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(57, ng0);

LAB3:    t1 = (t0 + 1340U);
    t2 = *((char **)t1);
    t3 = (11 - 11);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 4340);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 4116);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1483693708_3306564128_p_3(char *t0)
{
    char t15[16];
    char t17[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    unsigned char t14;
    char *t16;
    char *t18;
    char *t19;
    int t20;
    unsigned int t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;

LAB0:    xsi_set_current_line(61, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4124);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(62, ng0);
    t4 = (t0 + 1252U);
    t8 = *((char **)t4);
    t9 = (11 - 10);
    t10 = (t9 * 1U);
    t11 = (0 + t10);
    t4 = (t8 + t11);
    t12 = (t0 + 812U);
    t13 = *((char **)t12);
    t14 = *((unsigned char *)t13);
    t16 = ((IEEE_P_2592010699) + 2224);
    t18 = (t17 + 0U);
    t19 = (t18 + 0U);
    *((int *)t19) = 10;
    t19 = (t18 + 4U);
    *((int *)t19) = 0;
    t19 = (t18 + 8U);
    *((int *)t19) = -1;
    t20 = (0 - 10);
    t21 = (t20 * -1);
    t21 = (t21 + 1);
    t19 = (t18 + 12U);
    *((unsigned int *)t19) = t21;
    t12 = xsi_base_array_concat(t12, t15, t16, (char)97, t4, t17, (char)99, t14, (char)101);
    t19 = (t0 + 4376);
    t22 = (t19 + 32U);
    t23 = *((char **)t22);
    t24 = (t23 + 32U);
    t25 = *((char **)t24);
    memcpy(t25, t12, 12U);
    xsi_driver_first_trans_fast(t19);
    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

}

static void work_a_1483693708_3306564128_p_4(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;

LAB0:    xsi_set_current_line(65, ng0);
    t1 = (t0 + 1252U);
    t2 = *((char **)t1);
    t1 = (t0 + 6296U);
    t3 = (t0 + 6500);
    t5 = (t0 + 6232U);
    t6 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t3, t5);
    if (t6 != 0)
        goto LAB3;

LAB4:
LAB5:    t12 = (t0 + 4412);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = (unsigned char)2;
    xsi_driver_first_trans_fast(t12);

LAB2:    t17 = (t0 + 4132);
    *((int *)t17) = 1;

LAB1:    return;
LAB3:    t7 = (t0 + 4412);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = (t9 + 32U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_fast(t7);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_1483693708_3306564128_p_5(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    unsigned char t13;
    unsigned char t14;
    char *t15;
    unsigned char t16;
    unsigned char t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    static char *nl0[] = {&&LAB11, &&LAB11, &&LAB9, &&LAB10, &&LAB11, &&LAB11, &&LAB11, &&LAB11, &&LAB11};

LAB0:    xsi_set_current_line(69, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4140);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(70, ng0);
    t4 = (t0 + 1780U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t4 = (char *)((nl0) + t9);
    goto **((char **)t4);

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    goto LAB3;

LAB9:    xsi_set_current_line(73, ng0);
    t11 = (t0 + 1428U);
    t12 = *((char **)t11);
    t13 = *((unsigned char *)t12);
    t14 = (t13 == (unsigned char)3);
    if (t14 == 1)
        goto LAB15;

LAB16:    t10 = (unsigned char)0;

LAB17:    if (t10 != 0)
        goto LAB12;

LAB14:    xsi_set_current_line(76, ng0);
    t2 = (t0 + 4448);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 32U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);

LAB13:    goto LAB8;

LAB10:    xsi_set_current_line(80, ng0);
    t2 = (t0 + 1516U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB18;

LAB20:    t2 = (t0 + 1868U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB21;

LAB22:
LAB19:    goto LAB8;

LAB11:    xsi_set_current_line(87, ng0);
    t2 = (t0 + 4448);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 32U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    goto LAB8;

LAB12:    xsi_set_current_line(74, ng0);
    t11 = (t0 + 4448);
    t18 = (t11 + 32U);
    t19 = *((char **)t18);
    t20 = (t19 + 32U);
    t21 = *((char **)t20);
    *((unsigned char *)t21) = (unsigned char)3;
    xsi_driver_first_trans_fast(t11);
    goto LAB13;

LAB15:    t11 = (t0 + 1516U);
    t15 = *((char **)t11);
    t16 = *((unsigned char *)t15);
    t17 = (t16 == (unsigned char)2);
    t10 = t17;
    goto LAB17;

LAB18:    xsi_set_current_line(81, ng0);
    t2 = (t0 + 4448);
    t5 = (t2 + 32U);
    t8 = *((char **)t5);
    t11 = (t8 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    goto LAB19;

LAB21:    xsi_set_current_line(83, ng0);
    t2 = (t0 + 4448);
    t5 = (t2 + 32U);
    t8 = *((char **)t5);
    t11 = (t8 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    goto LAB19;

}

static void work_a_1483693708_3306564128_p_6(char *t0)
{
    char t17[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(95, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4148);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(96, ng0);
    t4 = (t0 + 1780U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)2);
    if (t10 != 0)
        goto LAB8;

LAB10:    t2 = (t0 + 1780U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB11;

LAB12:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(97, ng0);
    t4 = (t0 + 6512);
    t12 = (t0 + 4484);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    memcpy(t16, t4, 16U);
    xsi_driver_first_trans_fast(t12);
    goto LAB9;

LAB11:    xsi_set_current_line(99, ng0);
    t2 = (t0 + 1868U);
    t5 = *((char **)t2);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)2);
    if (t7 != 0)
        goto LAB13;

LAB15:    xsi_set_current_line(102, ng0);
    t2 = (t0 + 1604U);
    t4 = *((char **)t2);
    t2 = (t0 + 4484);
    t5 = (t2 + 32U);
    t8 = *((char **)t5);
    t11 = (t8 + 32U);
    t12 = *((char **)t11);
    memcpy(t12, t4, 16U);
    xsi_driver_first_trans_fast(t2);

LAB14:    goto LAB9;

LAB13:    xsi_set_current_line(100, ng0);
    t2 = (t0 + 1604U);
    t8 = *((char **)t2);
    t2 = (t0 + 6328U);
    t11 = ieee_p_3620187407_sub_4188545914_3620187407(IEEE_P_3620187407, t17, t8, t2, (unsigned char)3);
    t12 = (t0 + 4484);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    memcpy(t16, t11, 16U);
    xsi_driver_first_trans_fast(t12);
    goto LAB14;

}

static void work_a_1483693708_3306564128_p_7(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(111, ng0);

LAB3:    t1 = (t0 + 1604U);
    t2 = *((char **)t1);
    t3 = (13 - 15);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 4520);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 4156);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1483693708_3306564128_p_8(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    unsigned char t10;
    unsigned char t11;
    char *t12;
    unsigned char t13;
    unsigned char t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    xsi_set_current_line(115, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4164);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(116, ng0);
    t4 = (t0 + 1516U);
    t9 = *((char **)t4);
    t10 = *((unsigned char *)t9);
    t11 = (t10 == (unsigned char)3);
    if (t11 == 1)
        goto LAB11;

LAB12:    t8 = (unsigned char)0;

LAB13:    if (t8 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(119, ng0);
    t2 = (t0 + 1692U);
    t4 = *((char **)t2);
    t2 = (t0 + 4556);
    t5 = (t2 + 32U);
    t9 = *((char **)t5);
    t12 = (t9 + 32U);
    t15 = *((char **)t12);
    memcpy(t15, t4, 16U);
    xsi_driver_first_trans_fast(t2);

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(117, ng0);
    t4 = (t0 + 1604U);
    t15 = *((char **)t4);
    t4 = (t0 + 4556);
    t16 = (t4 + 32U);
    t17 = *((char **)t16);
    t18 = (t17 + 32U);
    t19 = *((char **)t18);
    memcpy(t19, t15, 16U);
    xsi_driver_first_trans_fast(t4);
    goto LAB9;

LAB11:    t4 = (t0 + 1780U);
    t12 = *((char **)t4);
    t13 = *((unsigned char *)t12);
    t14 = (t13 == (unsigned char)3);
    t8 = t14;
    goto LAB13;

}

static void work_a_1483693708_3306564128_p_9(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(124, ng0);

LAB3:    t1 = (t0 + 1692U);
    t2 = *((char **)t1);
    t1 = (t0 + 4592);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 4172);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1483693708_3306564128_p_10(char *t0)
{
    char t20[16];
    char t21[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    int t22;
    unsigned int t23;
    char *t24;
    char *t25;

LAB0:    xsi_set_current_line(128, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4180);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(129, ng0);
    t4 = (t0 + 636U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(132, ng0);
    t2 = (t0 + 1516U);
    t4 = *((char **)t2);
    t3 = *((unsigned char *)t4);
    t6 = (t3 == (unsigned char)3);
    if (t6 == 1)
        goto LAB14;

LAB15:    t1 = (unsigned char)0;

LAB16:    if (t1 != 0)
        goto LAB11;

LAB13:    t2 = (t0 + 1868U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB17;

LAB18:    xsi_set_current_line(137, ng0);
    t2 = (t0 + 1956U);
    t4 = *((char **)t2);
    t2 = (t0 + 4628);
    t5 = (t2 + 32U);
    t8 = *((char **)t5);
    t11 = (t8 + 32U);
    t12 = *((char **)t11);
    memcpy(t12, t4, 8U);
    xsi_driver_first_trans_fast(t2);

LAB12:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(130, ng0);
    t4 = xsi_get_transient_memory(8U);
    memset(t4, 0, 8U);
    t11 = t4;
    memset(t11, (unsigned char)2, 8U);
    t12 = (t0 + 4628);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    memcpy(t16, t4, 8U);
    xsi_driver_first_trans_fast(t12);
    goto LAB9;

LAB11:    xsi_set_current_line(133, ng0);
    t2 = (t0 + 1956U);
    t8 = *((char **)t2);
    t17 = (7 - 6);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t2 = (t8 + t19);
    t12 = ((IEEE_P_2592010699) + 2224);
    t13 = (t21 + 0U);
    t14 = (t13 + 0U);
    *((int *)t14) = 6;
    t14 = (t13 + 4U);
    *((int *)t14) = 0;
    t14 = (t13 + 8U);
    *((int *)t14) = -1;
    t22 = (0 - 6);
    t23 = (t22 * -1);
    t23 = (t23 + 1);
    t14 = (t13 + 12U);
    *((unsigned int *)t14) = t23;
    t11 = xsi_base_array_concat(t11, t20, t12, (char)97, t2, t21, (char)99, (unsigned char)3, (char)101);
    t14 = (t0 + 4628);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    t24 = (t16 + 32U);
    t25 = *((char **)t24);
    memcpy(t25, t11, 8U);
    xsi_driver_first_trans_fast(t14);
    goto LAB12;

LAB14:    t2 = (t0 + 1780U);
    t5 = *((char **)t2);
    t7 = *((unsigned char *)t5);
    t9 = (t7 == (unsigned char)3);
    t1 = t9;
    goto LAB16;

LAB17:    xsi_set_current_line(135, ng0);
    t2 = (t0 + 1956U);
    t5 = *((char **)t2);
    t17 = (7 - 6);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t2 = (t5 + t19);
    t11 = ((IEEE_P_2592010699) + 2224);
    t12 = (t21 + 0U);
    t13 = (t12 + 0U);
    *((int *)t13) = 6;
    t13 = (t12 + 4U);
    *((int *)t13) = 0;
    t13 = (t12 + 8U);
    *((int *)t13) = -1;
    t22 = (0 - 6);
    t23 = (t22 * -1);
    t23 = (t23 + 1);
    t13 = (t12 + 12U);
    *((unsigned int *)t13) = t23;
    t8 = xsi_base_array_concat(t8, t20, t11, (char)97, t2, t21, (char)99, (unsigned char)2, (char)101);
    t13 = (t0 + 4628);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 32U);
    t24 = *((char **)t16);
    memcpy(t24, t8, 8U);
    xsi_driver_first_trans_fast(t13);
    goto LAB12;

}

static void work_a_1483693708_3306564128_p_11(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(142, ng0);

LAB3:    t1 = (t0 + 1956U);
    t2 = *((char **)t1);
    t1 = (t0 + 4664);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 8U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 4188);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_1483693708_3306564128_init()
{
	static char *pe[] = {(void *)work_a_1483693708_3306564128_p_0,(void *)work_a_1483693708_3306564128_p_1,(void *)work_a_1483693708_3306564128_p_2,(void *)work_a_1483693708_3306564128_p_3,(void *)work_a_1483693708_3306564128_p_4,(void *)work_a_1483693708_3306564128_p_5,(void *)work_a_1483693708_3306564128_p_6,(void *)work_a_1483693708_3306564128_p_7,(void *)work_a_1483693708_3306564128_p_8,(void *)work_a_1483693708_3306564128_p_9,(void *)work_a_1483693708_3306564128_p_10,(void *)work_a_1483693708_3306564128_p_11};
	xsi_register_didat("work_a_1483693708_3306564128", "isim/_tmp/work/a_1483693708_3306564128.didat");
	xsi_register_executes(pe);
}
