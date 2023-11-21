using UnityEngine;
using extOSC;
using System.Collections.Generic;

public class OSCMessageController : MonoBehaviour
{
    public CloudManager cloudManager;
    private OSCReceiver receiver;
    private float xDir;
    private float yDir;
    private float zDir;

    protected virtual void Awake()
    {
        // Create OSC receiver and set the port number
        receiver = GetComponent<OSCReceiver>();
        receiver.LocalPort = 7001;
        receiver.Bind("/xDir", ReceivedXDir);
        receiver.Bind("/yDir", ReceivedYDir);
        receiver.Bind("/zDir", ReceivedZDir);
        receiver.Bind("/pattern", ReceivedPattern);
        receiver.Connect();
    }

    protected virtual void Start()
    {
    }

    protected virtual void Update()
    {
        cloudManager.UpdateCloud(new Vector3(xDir, yDir, zDir));
    }

    private void ReceivedXDir(OSCMessage message)
	{
        // Extract the value from the OSC message
        xDir = message.Values[0].FloatValue;
    }
	
    private void ReceivedYDir(OSCMessage message)
	{
        yDir = message.Values[0].FloatValue;
    }
	
    private void ReceivedZDir(OSCMessage message)
	{
        zDir = message.Values[0].FloatValue;
    }

    private void ReceivedPattern(OSCMessage message)
	{
		Debug.Log(message.Values[0].FloatValue);
    }
}