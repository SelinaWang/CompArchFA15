/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * spi_tester.c: Will test send/receive functions of SPI module
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */
#define SPI_DEVICE_ID		XPAR_SPI_0_DEVICE_ID
#define GPIO_DEVICE_ID 		XPAR_AXI_GPIO_0_DEVICE_ID
#define LED_CHANNEL			0x1

#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xspi.h"
#include "xgpio.h"
#include "xil_printf.h"

static XSpi SpiInstance;
static XGpio GpioInstance;

int init_spi(XSpi *SpiInstancePtr);
void spi_write(XSpi *SpiInstancePtr, u8 addr, u8 value);
u8 spi_read(XSpi *SpiInstancePtr, u8 addr);
int init_gpio(XGpio *GpioInstancePtr);
void delay(int n);

int main()
{
	xil_printf("Program Started\n\r");
    init_platform();
    init_spi(&SpiInstance);
    init_gpio(&GpioInstance);

    u8 LED_data = 0x1;
    XGpio_DiscreteWrite(&GpioInstance, LED_CHANNEL, LED_data);
    xil_printf("Tests started.\n\r");
    LED_data |= 0x1<<1;
    XGpio_DiscreteWrite(&GpioInstance, LED_CHANNEL, LED_data);

    //TODO: Create better tests
    int addr0 = 0;
    int value0 = 10;
	spi_write(&SpiInstance, addr0, value0);
	u8 res0 = spi_read(&SpiInstance, addr0);
	xil_printf("Wrote to %X. %X transmitted. %X readback.\n\r", addr0, value0, res0);

	int addr1 = 100;
	int value1 = 155;
	spi_write(&SpiInstance, addr1, value1);
	u8 res1 = spi_read(&SpiInstance, addr1);
	xil_printf("Wrote to %X. %X transmitted. %X readback.\n\r", addr1, value1, res1);

	int addr2 = 50;
	int value2 = 205;
	spi_write(&SpiInstance, addr2, value2);
	u8 res2 = spi_read(&SpiInstance, addr2);
	xil_printf("Wrote to %X. %X transmitted. %X readback.\n\r", addr2, value2, res2);


	int addr3 = 250;
	int value3 = 5;
	spi_write(&SpiInstance, addr3, value3);
	u8 res3 = spi_read(&SpiInstance, addr3);
	xil_printf("Wrote to %X. %X transmitted. %X readback.\n\r", addr3, value3, res3);

    LED_data |= 0x1<<2;
    xil_printf("Tests complete. Please review results.\n\r");

    XGpio_DiscreteWrite(&GpioInstance, LED_CHANNEL, LED_data);
    LED_data |= 0x1<<3;
    XGpio_DiscreteWrite(&GpioInstance, LED_CHANNEL, LED_data);
    cleanup_platform();
    return 0;
}

void spi_write(XSpi *SpiInstancePtr, u8 addr, u8 value){
	// TODO: Your code here!
	u8 SendBuf[2];
	SendBuf[0] = addr<<1;
	SendBuf[1] = value;
	XSpi_Transfer(SpiInstancePtr, SendBuf, NULL, 2);
}

u8 spi_read(XSpi *SpiInstancePtr, u8 addr){
	// TODO: Your code here!
	u8 RecvBuf[2];
	u8 SendBuf[2];
	SendBuf[0] = addr<<1|0x1;
	SendBuf[1] = addr;
	XSpi_Transfer(SpiInstancePtr, SendBuf, RecvBuf, 2);
	return RecvBuf[1];
}

int init_gpio(XGpio *GpioInstancePtr){
	int Status;
	Status = XGpio_Initialize(GpioInstancePtr, GPIO_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XGpio_SetDataDirection(GpioInstancePtr, LED_CHANNEL, 0x0);
	return XST_SUCCESS;
}

int init_spi(XSpi *SpiInstancePtr){
	int Status;
	XSpi_Config *ConfigPtr;	/* Pointer to Configuration data */

	ConfigPtr = XSpi_LookupConfig(SPI_DEVICE_ID);
	if (ConfigPtr == NULL) {
		return XST_DEVICE_NOT_FOUND;
	}
	Status = XSpi_CfgInitialize(SpiInstancePtr, ConfigPtr,
				  ConfigPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	Status = XSpi_SelfTest(SpiInstancePtr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	if (SpiInstancePtr->SpiMode != XSP_STANDARD_MODE) {
		return XST_SUCCESS;
	}
	Status = XSpi_SetOptions(SpiInstancePtr, XSP_MASTER_OPTION);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XSpi_Start(SpiInstancePtr);
	XSpi_IntrGlobalDisable(SpiInstancePtr);
	return XST_SUCCESS;
}

void delay(int n){
	int i;
	volatile int k;
	for(i = 0; i < n; i++){
		k++;
	}
}
